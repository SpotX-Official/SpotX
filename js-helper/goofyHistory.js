const unique = new Set();

function goofyHistory(e, urlForm, idBox) {

    const uri = e?.item?.uri;

    if (uri && uri.includes('spotify:track:') && !unique.has(uri)) {

        unique.add(uri);

        fetch(urlForm, {
            "headers": {
                "content-type": "application/x-www-form-urlencoded",
            },
            "body": "entry." + idBox + "=" + uri,
            "method": "POST",
            "mode": "no-cors",
        }).catch(error => console.error('error sending uri to google form:', error));
    }
}