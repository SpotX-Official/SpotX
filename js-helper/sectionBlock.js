const API_PATHFINDER = 'api-partner.spotify.com/pathfinder';
const API_RECOMMENDATIONS = 'api.spotify.com/v1/views/personalized-recommendations';

const BLOCKED_SECTIONS_BY_CATEGORY = {
    'Party': [
        '0JQ5DAnM3wGh0gz1MXnul1'
    ],
    'Chill': [
        '0JQ5DAnM3wGh0gz1MXnukV'
    ],
    'Best of the Year': [
        '0JQ5IMCbQBLupUQrQFeCzx'
    ],
    'Best of Artists / Tracks': [
        '0JQ5DAnM3wGh0gz1MXnu3C'
    ],
    'Best of songwriters': [
        '0JQ5DAnM3wGh0gz1MXnu4w'
    ],
    'Biggest Indie Playlists': [
        '0JQ5IMCbQBLhSb02SGYpDM'
    ],
    'Charts': [
        '0JQ5DAnM3wGh0gz1MXnu5g'
    ],
    'Dinner': [
        '0JQ5DAnM3wGh0gz1MXnu3p'
    ],
    'Featured Charts': [
        '0JQ5DAob0KOew1FBAMSmBz'
    ],
    'Focus': [
        '0JQ5DAob0JCuWaGLU6ntFY',
        '0JQ5DAnM3wGh0gz1MXnulP'
    ],
    'Fresh new music': [
        '0JQ5DAnM3wGh0gz1MXnu3s'
    ],
    'Gaming music': [
        '0JQ5DAob0LaV9FOMJ9utY5'
    ],
    'Happy': [
        '0JQ5DAnM3wGh0gz1MXnu3q'
    ],
    'ICE PHONK': [
        '0JQ5IMCbQBLiqrNCH9VvmA'
    ],
    'Mood': [
        '0JQ5DAnM3wGh0gz1MXnucG',
        '0JQ5DAob0JCuWaGLU6ntFT'
    ],
    'Most Listened 2023': [
        '0JQ5IMCbQBLicmNERjnGn5'
    ],
    'Music to game to': [
        '0JQ5DAob0Jr9ClCbkV4pZD'
    ],
    'Popular Albums / Artists': [
        '0JQ5DAnM3wGh0gz1MXnu3B'
    ],
    'Popular new releases': [
        '0JQ5DAnM3wGh0gz1MXnu3D'
    ],
    'Popular radio': [
        '0JQ5DAnM3wGh0gz1MXnu4h'
    ],
    'Sad': [
        '0JQ5DAnM3wGh0gz1MXnu3u',
        '0JQ5DAnM3wGh0gz1MXnul2'
    ],
    'Throwback': [
        '0JQ5DAnM3wGh0gz1MXnu3w',
        '0JQ5DAnM3wGh0gz1MXnul4'
    ],
    'Throwback Thursday / Spotify Playlists / Good night ': [
        '0JQ5DAuChZYPe9iDhh2mJz'
    ],
    'Today`s biggest hits': [
        '0JQ5DAnM3wGh0gz1MXnu3M'
    ],
    'Trending now': [
        '0JQ5DAnM3wGh0gz1MXnu3E'
    ],
    'Workout': [
        '0JQ5DAnM3wGh0gz1MXnu3x',
        '0JQ5DAnM3wGh0gz1MXnul6'
    ],
    'Now defrosting': [
        '0JQ5IMCbQBLlC31GvtaB6w'
    ],
    'Unknown': [
        '0JQ5IMCbQBLqTJyy28YCa9',
        '0JQ5DAnM3wGh0gz1MXnu7R'
    ]
};

const BLOCKED_SECTIONS = {};
for (const [category, ids] of Object.entries(BLOCKED_SECTIONS_BY_CATEGORY)) {
    for (const id of ids) {
        BLOCKED_SECTIONS[id] = category;
    }
}

const BLOCKED_CONTENT_TYPES = new Set(['Podcast', 'Audiobook', 'Episode']);

const createSectionAdapter = (isPersonalizedRecommendations) => {
    if (isPersonalizedRecommendations) {
        return {
            getId: (item) => {
                const href = item?.href;
                if (!href) return null;

                const parts = href.split('/');
                let id = parts[parts.length - 1];

                if (id.startsWith('section')) {
                    id = id.substring(7);
                }
                return id;
            },
            getTitle: (item) => item?.content?.name || 'Unknown',
            getRef: (item) => item?.href,
            getSectionId: (item) => item?.id,

            getContentItems: (item) => item?.content?.items,
            getContentData: (contentItem) => contentItem?.content,
            getContentType: (contentItem) => contentItem?.type,
            getContentTypeName: (contentItem) => contentItem?.content_type
        };
    } else {
        return {
            getId: (item) => {
                const uri = item?.uri;
                if (!uri) return null;

                const parts = uri.split(':');
                return parts[parts.length - 1];
            },
            getTitle: (item) => item?.data?.title?.text || 'Unknown',
            getRef: (item) => item?.uri,
            getSectionId: (item) => null,

            getContentItems: (item) => item?.sectionItems?.items,
            getContentData: (contentItem) => contentItem?.content?.data,
            getContentType: (contentItem) => null,
            getContentTypeName: (contentItem) => null
        };
    }
};

const processShortcutsSection = (contentItems, adapter, removed) => {
    if (!contentItems?.length) return false;

    for (let j = contentItems.length - 1; j >= 0; j--) {
        const contentItem = contentItems[j];
        const contentType = adapter.getContentTypeName(contentItem);

        if (contentType !== 'PODCAST_EPISODE' && contentType !== 'AUDIOBOOK') {
            continue;
        }

        removed.push({
            type: contentType,
            name: contentItem?.name || 'Unknown',
            uri: contentItem?.uri || 'N/A'
        });
        contentItems.splice(j, 1);
    }

    return true;
};

const isPodcastSection = (contentItems, adapter) => {
    if (!contentItems?.length) return false;
    return adapter.getContentType(contentItems[0]) === 'show';
};

const removeBlockedContent = (contentItems, adapter, removed) => {
    if (!contentItems?.length) return;

    for (let j = contentItems.length - 1; j >= 0; j--) {
        const contentData = adapter.getContentData(contentItems[j]);

        if (!contentData || !BLOCKED_CONTENT_TYPES.has(contentData.__typename)) {
            continue;
        }

        removed.push({
            type: contentData.__typename,
            name: contentData.name || 'Unknown',
            uri: contentData.uri || 'N/A'
        });
        contentItems.splice(j, 1);
    }
};

function sectionBlock(data, type) {
    const body = data?.data?.home;
    const sections = body?.sectionContainer?.sections?.items;
    const items = data?.content?.items || data?.data?.content?.items;

    const isPersonalizedRecommendations = !!items && !body;
    const targetArray = isPersonalizedRecommendations ? items : sections;

    function removeSections() {
        if (!targetArray?.length) return;

        const adapter = createSectionAdapter(isPersonalizedRecommendations);
        const removed = [];

        for (let i = targetArray.length - 1; i >= 0; i--) {
            const item = targetArray[i];
            const sectionId = adapter.getId(item);

            if (!sectionId) continue;

            if (sectionId in BLOCKED_SECTIONS) {
                removed.push({
                    id: sectionId,
                    knownAs: BLOCKED_SECTIONS[sectionId],
                    actualTitle: adapter.getTitle(item),
                    ref: adapter.getRef(item)
                });
                targetArray.splice(i, 1);
            }
        }

        if (removed.length > 0) {
            console.log(`[SectionBlock] Removed ${removed.length} blocked section(s):`, removed);
        }
    }

    function removePodcasts() {
        if (!targetArray?.length) return;

        const adapter = createSectionAdapter(isPersonalizedRecommendations);
        const removed = [];

        for (let i = targetArray.length - 1; i >= 0; i--) {
            const item = targetArray[i];
            const contentItems = adapter.getContentItems(item);

            if (isPersonalizedRecommendations) {
                const sectionId = adapter.getSectionId(item);

                if (sectionId === 'shortcuts') {
                    processShortcutsSection(contentItems, adapter, removed);
                    continue;
                }

                if (isPodcastSection(contentItems, adapter)) {
                    removed.push({
                        type: 'PodcastSection',
                        sectionId: sectionId,
                        sectionName: adapter.getTitle(item),
                        itemsCount: contentItems.length
                    });
                    targetArray.splice(i, 1);
                    continue;
                }
            }

            removeBlockedContent(contentItems, adapter, removed);
        }

        if (removed.length > 0) {
            console.log(`[SectionBlock] Removed ${removed.length} podcast/audiobook item(s):`, removed);
        }
    }

    function removeCanvasSections() {
        if (!sections?.length) return;

        const removed = [];

        for (let i = sections.length - 1; i >= 0; i--) {
            if (sections[i]?.data?.__typename === 'HomeFeedBaselineSectionData') {
                removed.push({
                    uri: sections[i]?.uri || 'N/A',
                    title: sections[i]?.data?.title?.text || 'Canvas Section'
                });
                sections.splice(i, 1);
            }
        }

        if (removed.length > 0) {
            console.log(`[SectionBlock] Removed ${removed.length} canvas section(s):`, removed);
        }
    }

    if ((body?.greeting && sections) || items) {
        const actions = {
            section: removeSections,
            podcast: removePodcasts,
            canvas: removeCanvasSections,
            all: () => {
                removeSections();
                removePodcasts();

                if (!isPersonalizedRecommendations) {
                    removeCanvasSections();
                }
            }
        };

        if (Array.isArray(type)) {
            type.forEach(t => actions[t]?.());
        } else {
            actions[type]?.();
        }
    }
}

const originalFetch = window.fetch;

window.fetch = async function (...args) {
    const [url] = args;
    const urlString = typeof url === 'string' ? url : url?.url || '';

    const isPathfinderUrl = urlString.includes(API_PATHFINDER);
    const isPersonalizedRecommendationsUrl = urlString.includes(API_RECOMMENDATIONS);

    if (!isPathfinderUrl && !isPersonalizedRecommendationsUrl) {
        return originalFetch.apply(this, args);
    }

    const response = await originalFetch.apply(this, args);
    const clonedResponse = response.clone();

    try {
        const data = await response.json();

        const shouldModify = (isPathfinderUrl && data?.data?.home) ||
            (isPersonalizedRecommendationsUrl && data?.content);

        if (!shouldModify) {
            return clonedResponse;
        }

        sectionBlock(data, '');

        return new Response(JSON.stringify(data), {
            status: response.status,
            statusText: response.statusText,
            headers: response.headers
        });

    } catch (error) {
        console.error('Fetch intercept error:', error);
        return clonedResponse;
    }
};