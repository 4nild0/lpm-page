const API_URL = 'http://localhost:8080';

let currentView = 'dashboard';

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
    }
}

async function loadPackages() {
    const container = document.getElementById('packageList');
    container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading packages...</p></div>';

    try {
        const response = await fetch(`${API_URL}/packages`);
        const data = await response.text();

        if (!data || data.trim() === '') {
            container.innerHTML = '<p class="text-muted">No packages available</p>';
            return;
        }

        const packages = data.trim().split('\n').filter(p => p);

        let html = '<table><thead><tr><th>Package Name</th><th>Actions</th></tr></thead><tbody>';
        packages.forEach(pkg => {
            html += `
                <tr>
                    <td>${pkg}</td>
                    <td>
                        <button class="secondary" onclick="downloadPackage('${pkg}')">Download</button>
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

async function downloadPackage(name) {
    try {
        const parts = name.split('@');
        const pkgName = parts[0];
        const pkgVersion = parts[1] || '1.0.0';

        const response = await fetch(`${API_URL}/packages/${pkgName}/${pkgVersion}`);
        if (!response.ok) {
            throw new Error('Package not found');
        }

        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${pkgName}-${pkgVersion}.zip`;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);

        showMessage('success', `Downloaded ${pkgName} v${pkgVersion}`);
    } catch (error) {
        showMessage('error', `Download failed: ${error.message}`);
    }
}

function showMessage(type, text) {
    const msg = document.getElementById('uploadMsg');
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
                'Authorization': 'Bearer lpm-secret-token',
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
    try {
        const response = await fetch(`${API_URL}/packages`);
        const data = await response.text();
        const count = data ? data.trim().split('\n').filter(p => p).length : 0;

        document.getElementById('stats').innerHTML = `
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
        document.getElementById('stats').innerHTML = `
            <div class="message error">Failed to load stats: ${error.message}</div>
        `;
    }
}

window.addEventListener('DOMContentLoaded', () => {
    showView('dashboard');
    loadStats();
});
