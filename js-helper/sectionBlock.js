function sectionBlock(e, type) {

    const body = e?.data?.home;
    const sections = body?.sectionContainer?.sections?.items;

    function removeSections() {
        const sectionsData = [
            { id: '0JQ5IMCbQBLupUQrQFeCzx', name: 'Best of the Year' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3C', name: 'Best of Artists / Tracks' },
            { id: '0JQ5DAnM3wGh0gz1MXnu4w', name: 'Best of songwriters' },
            { id: '0JQ5IMCbQBLhSb02SGYpDM', name: 'Biggest Indie Playlists' },
            { id: '0JQ5DAnM3wGh0gz1MXnu5g', name: 'Charts' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3p', name: 'Dinner' },
            { id: '0JQ5DAob0KOew1FBAMSmBz', name: 'Featured Charts' },
            { id: '0JQ5DAob0JCuWaGLU6ntFY', name: 'Focus' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3s', name: 'Fresh new music' },
            { id: '0JQ5DAob0LaV9FOMJ9utY5', name: 'Gaming music' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3q', name: 'Happy' },
            { id: '0JQ5IMCbQBLiqrNCH9VvmA', name: 'ICE PHONK' },
            { id: '0JQ5DAnM3wGh0gz1MXnucG', name: 'Mood' },
            { id: '0JQ5DAob0JCuWaGLU6ntFT', name: 'Mood' },
            { id: '0JQ5IMCbQBLicmNERjnGn5', name: 'Most Listened 2023' },
            { id: '0JQ5DAob0Jr9ClCbkV4pZD', name: 'Music to game to' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3B', name: 'Popular Albums / Artists' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3D', name: 'Popular new releases' },
            { id: '0JQ5DAnM3wGh0gz1MXnu4h', name: 'Popular radio' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3u', name: 'Sad' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3w', name: 'Throwback' },
            { id: '0JQ5DAuChZYPe9iDhh2mJz', name: 'Throwback Thursday / Spotify Playlists' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3M', name: 'Today`s biggest hits' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3E', name: 'Trending now' },
            { id: '0JQ5DAnM3wGh0gz1MXnu3x', name: 'Workout' },
            { id: '0JQ5IMCbQBLqTJyy28YCa9', name: '?' },
            { id: '0JQ5IMCbQBLlC31GvtaB6w', name: '?' },
            { id: '0JQ5DAnM3wGh0gz1MXnu7R', name: '?' }
        ];
        const sectionIdsRegex = new RegExp(sectionsData.map(section => section.id).join('|'));

        for (let i = sections.length - 1; i >= 0; i--) {
            const uri = sections[i]?.uri;
            if (uri && uri.match(sectionIdsRegex)) {
                sections.splice(i, 1);
            }
        }
    }

    function removePodcasts() {
        if (Array.isArray(sections)) {
            for (let i = 0; i < sections.length; i++) {
                const sectionItems = sections[i]?.sectionItems?.items;

                if (Array.isArray(sectionItems)) {
                    for (let j = 0; j < sectionItems.length; j++) {
                        const contentData = sectionItems[j]?.content?.data;

                        if (contentData && ["Podcast", "Audiobook", "Episode"].includes(contentData.__typename)) {
                            sectionItems.splice(j, 1);
                            j--;
                        }
                    }
                }
            }
        }
    }

    function removeCanvasSections() {
        if (Array.isArray(sections)) {
            for (let i = sections.length - 1; i >= 0; i--) {

                const sectionDataTypename = sections[i]?.data?.__typename;

                if (sectionDataTypename === 'HomeFeedBaselineSectionData') {
                    sections.splice(i, 1);
                }
            }
        }
    }

    if (body?.greeting && sections) {
        const actions = {
            section: removeSections,
            podcast: removePodcasts,
            canvas: removeCanvasSections,
            all: () => {
                removeSections();
                removePodcasts();
                removeCanvasSections();
            }
        };
        if (Array.isArray(type)) {
            type.forEach(t => actions[t]?.());
        } else {
            actions[type]?.();
        }
    }
}