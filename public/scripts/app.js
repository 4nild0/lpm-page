const API_URL = 'http://localhost:8080';
const AUTH_TOKEN = 'Bearer lpm-secret-token';

let currentView = 'dashboard';
let currentPackage = null;

function showView(viewId) {
    document.querySelectorAll('.view').forEach(el => el.classList.add('hidden'));
    document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));

    const view = document.getElementById(viewId);
    if (view) {
        view.classList.remove('hidden');
        currentView = viewId;
    }

    const navItem = document.querySelector(`[data-view="${viewId}"]`);
    if (navItem) {
        navItem.classList.add('active');
    }

    if (viewId === 'packages') {
        loadPackages();
    } else if (viewId === 'dashboard') {
        loadStats();
    }
}

async function loadPackages() {
    const container = document.getElementById('packageList');
    if (!container) {
        console.error('Package list container not found');
        return;
    }
    
    container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading packages...</p></div>';

    try {
        console.log('Loading packages from:', `${API_URL}/packages`);
        const response = await fetch(`${API_URL}/packages`);
        console.log('Response status:', response.status, response.statusText);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const packages = await response.json();
        console.log('Packages loaded:', packages);

        if (!packages || packages.length === 0) {
            container.innerHTML = '<p class="text-muted">No packages available</p>';
            return;
        }

        let html = '<table><thead><tr><th>Package Name</th><th>Version</th><th>Actions</th></tr></thead><tbody>';
        packages.forEach(pkg => {
            html += `
                <tr>
                    <td><strong>${pkg.name}</strong></td>
                    <td>${pkg.version}</td>
                    <td class="actions">
                        <button class="btn-small" onclick="viewPackage('${pkg.name}', '${pkg.version}')">View</button>
                        <button class="btn-small secondary" onclick="downloadPackage('${pkg.name}', '${pkg.version}')">Download</button>
                        <button class="btn-small warning" onclick="editPackage('${pkg.name}', '${pkg.version}')">Edit</button>
                        <button class="btn-small danger" onclick="deletePackage('${pkg.name}', '${pkg.version}')">Delete</button>
                    </td>
                </tr>
            `;
        });
        html += '</tbody></table>';

        container.innerHTML = html;
    } catch (error) {
        container.innerHTML = `<div class="message error">Failed to load packages: ${error.message}</div>`;
    }
}

async function viewPackage(name, version) {
    try {
        const response = await fetch(`${API_URL}/packages/${name}/${version}`);
        if (!response.ok) {
            throw new Error('Package not found');
        }
        
        const pkg = await response.json();
        currentPackage = pkg;

        const detailView = document.getElementById('package-detail');
        const detailContent = document.getElementById('package-detail-content');
        const detailTitle = document.getElementById('detail-title');

        detailTitle.textContent = `${pkg.name} v${pkg.version}`;
        
        const sizeKB = pkg.size ? (pkg.size / 1024).toFixed(2) : 'Unknown';
        
        detailContent.innerHTML = `
            <div class="package-info">
                <div class="info-row">
                    <strong>Name:</strong> ${pkg.name}
                </div>
                <div class="info-row">
                    <strong>Version:</strong> ${pkg.version}
                </div>
                <div class="info-row">
                    <strong>Size:</strong> ${sizeKB} KB
                </div>
                ${pkg.metadata ? `
                    <div class="info-row">
                        <strong>Author:</strong> ${pkg.metadata.author || 'Unknown'}
                    </div>
                    <div class="info-row">
                        <strong>Description:</strong> ${pkg.metadata.description || 'No description'}
                    </div>
                ` : ''}
                <div class="actions">
                    <button onclick="downloadPackage('${pkg.name}', '${pkg.version}')">Download</button>
                    <button class="warning" onclick="editPackage('${pkg.name}', '${pkg.version}')">Edit</button>
                    <button class="danger" onclick="deletePackage('${pkg.name}', '${pkg.version}')">Delete</button>
                    <button class="secondary" onclick="showView('packages')">Back to List</button>
                </div>
            </div>
        `;

        document.querySelectorAll('.view').forEach(el => el.classList.add('hidden'));
        detailView.classList.remove('hidden');
    } catch (error) {
        showMessage('error', `Failed to load package: ${error.message}`);
    }
}

async function editPackage(name, version) {
    currentPackage = { name, version };
    
    const detailView = document.getElementById('package-detail');
    const detailContent = document.getElementById('package-detail-content');
    const detailTitle = document.getElementById('detail-title');

    detailTitle.textContent = `Edit ${name} v${version}`;
    
    detailContent.innerHTML = `
        <form id="editForm">
            <div class="form-group">
                <label for="editName">Package Name</label>
                <input type="text" id="editName" value="${name}" required>
            </div>
            <div class="form-group">
                <label for="editVersion">Version</label>
                <input type="text" id="editVersion" value="${version}" required>
            </div>
            <div class="form-group">
                <label for="editFile">New Package Archive (.zip)</label>
                <input type="file" id="editFile" accept=".zip" required>
            </div>
            <div class="actions">
                <button type="submit">Update Package</button>
                <button type="button" class="secondary" onclick="viewPackage('${name}', '${version}')">Cancel</button>
            </div>
        </form>
    `;

    document.getElementById('editForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        await updatePackage(name, version);
    });

    document.querySelectorAll('.view').forEach(el => el.classList.add('hidden'));
    detailView.classList.remove('hidden');
}

async function updatePackage(oldName, oldVersion) {
    const newName = document.getElementById('editName').value;
    const newVersion = document.getElementById('editVersion').value;
    const fileInput = document.getElementById('editFile');
    const file = fileInput.files[0];

    if (!file) {
        showMessage('error', 'Please select a file');
        return;
    }

    showMessage('success', 'Updating package...');

    try {
        const buffer = await file.arrayBuffer();

        const response = await fetch(`${API_URL}/packages/${newName}/${newVersion}`, {
            method: 'PUT',
            headers: {
                'Authorization': AUTH_TOKEN,
                'Content-Type': 'application/zip'
            },
            body: buffer
        });

        if (response.ok) {
            showMessage('success', 'Package updated successfully!');
            if (oldName !== newName || oldVersion !== newVersion) {
                await deletePackage(oldName, oldVersion, false);
            }
            showView('packages');
            return;
        }

        const text = await response.text();
        showMessage('error', `Update failed: ${text}`);
    } catch (error) {
        showMessage('error', `Connection error: ${error.message}`);
    }
}

async function deletePackage(name, version, confirmFirst = true) {
    if (confirmFirst && !confirm(`Are you sure you want to delete ${name}@${version}?`)) {
        return;
    }

    try {
        const response = await fetch(`${API_URL}/packages/${name}/${version}`, {
            method: 'DELETE',
            headers: {
                'Authorization': AUTH_TOKEN
            }
        });

        if (response.ok) {
            showMessage('success', `Package ${name}@${version} deleted successfully!`);
            if (currentView === 'packages') {
                loadPackages();
            } else {
                showView('packages');
            }
        } else {
            const text = await response.text();
            showMessage('error', `Delete failed: ${text}`);
        }
    } catch (error) {
        showMessage('error', `Connection error: ${error.message}`);
    }
}

async function downloadPackage(name, version) {
    try {
        const response = await fetch(`${API_URL}/packages/${name}/${version}/download`);
        if (!response.ok) {
            throw new Error('Package not found');
        }

        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${name}-${version}.zip`;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);

        showMessage('success', `Downloaded ${name} v${version}`);
    } catch (error) {
        showMessage('error', `Download failed: ${error.message}`);
    }
}

function showMessage(type, text) {
    const msg = document.getElementById('uploadMsg');
    if (!msg) return;
    
    msg.className = `message ${type}`;
    msg.textContent = text;
    msg.style.display = 'block';

    setTimeout(() => {
        msg.style.display = 'none';
    }, 5000);
}

document.getElementById('uploadForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const name = document.getElementById('pkgName').value;
    const version = document.getElementById('pkgVersion').value;
    const fileInput = document.getElementById('pkgFile');
    const file = fileInput.files[0];

    if (!file) {
        showMessage('error', 'Please select a file');
        return;
    }

    showMessage('success', 'Uploading...');

    try {
        const buffer = await file.arrayBuffer();

        const response = await fetch(`${API_URL}/packages/${name}/${version}`, {
            method: 'POST',
            headers: {
                'Authorization': AUTH_TOKEN,
                'Content-Type': 'application/zip'
            },
            body: buffer
        });

        if (response.ok) {
            showMessage('success', 'Package uploaded successfully!');
            e.target.reset();
            if (currentView === 'packages') {
                loadPackages();
            }
            return;
        }

        const text = await response.text();
        showMessage('error', `Upload failed: ${text}`);
    } catch (error) {
        showMessage('error', `Connection error: ${error.message}`);
    }
});

async function loadStats() {
    const statsElement = document.getElementById('stats');
    if (!statsElement) {
        console.error('Stats element not found');
        return;
    }
    
    try {
        console.log('Loading stats from:', `${API_URL}/packages`);
        const response = await fetch(`${API_URL}/packages`);
        console.log('Response status:', response.status, response.statusText);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const packages = await response.json();
        console.log('Packages loaded:', packages);
        const count = packages ? packages.length : 0;

        statsElement.innerHTML = `
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${count}</div>
                    <div class="stat-label">Total Packages</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">✓</div>
                    <div class="stat-label">Server Online</div>
                </div>
            </div>
        `;
    } catch (error) {
        console.error('Error loading stats:', error);
        statsElement.innerHTML = `
            <div class="message error">Failed to load stats: ${error.message}</div>
        `;
    }
}

window.addEventListener('DOMContentLoaded', () => {
    showView('dashboard');
    loadStats();
});
