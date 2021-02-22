    /**
     * Проверяет элемент на попадание в видимую часть экрана.
     * Для попадания достаточно, чтобы верхняя или нижняя границы элемента были видны.
     */
    function isVisible(elem) {
        var coords = elem.getBoundingClientRect();
        var windowHeight = document.documentElement.clientHeight;
        // верхняя граница elem в пределах видимости ИЛИ нижняя граница видима
        var topVisible = coords.top > 0 && coords.top < windowHeight;
        var bottomVisible = coords.bottom < windowHeight && coords.bottom > 0;
        return topVisible || bottomVisible;
    }
    /* Lazy Loading Images */
    function showVisible() {
        var imgs = document.querySelectorAll('img.lazy');
        for (var i = 0; i < imgs.length; i++) {
            var img = imgs[i];
            var realsrc = img.getAttribute('data-src');
            if (!realsrc)
                continue;
            if (isVisible(img)) {
                img.src = realsrc;
            }
        }
    }
    window.onscroll = showVisible;
    showVisible();
