window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.transactionType === 'playSound') {
        let audioPlayer = document.getElementById('audioPlayer');
        audioPlayer.src = data.transactionFile;
        audioPlayer.volume = data.transactionVolume;
        audioPlayer.loop = data.transactionLoop;
        audioPlayer.play();
        document.getElementById('player-container').style.display = 'block';
    }
});
