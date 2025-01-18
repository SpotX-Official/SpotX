// max track buffer for localStorage
// when the limit is reached, old tracks will be removed from the beginning, and new ones will be added to the end
const MAX_TRACKS = 1000;

// max delay between switching tracks (ms)
const MAX_DELAY = 1000;

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

const loadTracksFromStorage = () => {
    try {
        const savedTracks = localStorage.getItem('sentSpotifyTracks');
        return new Set(savedTracks ? JSON.parse(savedTracks) : []);
    } catch (error) {
        console.error('Error loading tracks from localStorage:', error);
        return new Set();
    }
};

const saveTracksToStorage = (tracks) => {
    try {
        let tracksArray = [...tracks];

        if (tracksArray.length > MAX_TRACKS) {
            tracksArray = tracksArray.slice(-MAX_TRACKS);
        }

        localStorage.setItem('sentSpotifyTracks', JSON.stringify(tracksArray));
    } catch (error) {
        console.error('Error saving tracks to localStorage:', error);
    }
};

const unique = loadTracksFromStorage();

async function sendToGoogleForm(uri, urlForm, idBox) {
    try {
        await fetch(urlForm, {
            "headers": {
                "content-type": "application/x-www-form-urlencoded",
            },
            "body": "entry." + idBox + "=" + uri,
            "method": "POST",
            "mode": "no-cors",
        });
        saveTracksToStorage(unique);
    } catch (error) {
        console.error('Error sending uri to google form:', error);
    }
}

const goofyHistory = debounce(async (e, urlForm, idBox) => {
    const uri = e?.item?.uri;
    if (uri && uri.includes('spotify:track:') && !unique.has(uri)) {
        unique.add(uri);
        await sendToGoogleForm(uri, urlForm, idBox);
    }
}, MAX_DELAY);