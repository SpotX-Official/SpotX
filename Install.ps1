param
(
    [Parameter(HelpMessage = 'Remove podcasts from homepage.')]
    [switch]$podcasts_off,
    
    [Parameter(HelpMessage = 'Do not remove podcasts from homepage.')]
    [switch]$podcasts_on,
    
    [Parameter(HelpMessage = 'Block Spotify automatic updates.')]
    [switch]$block_update_on,
    
    [Parameter(HelpMessage = 'Do not block Spotify automatic updates.')]
    [switch]$block_update_off,
    
    [Parameter(HelpMessage = 'Enable clear cache.')]
    [switch]$cache_on,
    
    [Parameter(HelpMessage = 'Specify the number of days. Default is 7 days.')]
    [int16]$number_days = 7,
    
    [Parameter(HelpMessage = 'Do not enable cache clearing.')]
    [switch]$cache_off,
    
    [Parameter(HelpMessage = 'Automatic uninstallation of Spotify MS if it was found.')]
    [switch]$confirm_uninstall_ms_spoti,
    
    [Parameter(HelpMessage = 'Overwrite outdated or unsupported version of Spotify with the recommended version.')]
    [switch]$confirm_spoti_recomended_over,
    
    [Parameter(HelpMessage = 'Uninstall outdated or unsupported version of Spotify and install the recommended version.')]
    [switch]$confirm_spoti_recomended_unistall,
    
    [Parameter(HelpMessage = 'Installation without ad blocking for premium accounts.')]
    [switch]$premium,
    
    [Parameter(HelpMessage = 'Automatic launch of Spotify after installation is complete.')]
    [switch]$start_spoti,
    
    [Parameter(HelpMessage = 'Experimental features operated by Spotify.')]
    [switch]$exp_spotify,

    [Parameter(HelpMessage = 'Experimental features of SpotX are not included')]
    [switch]$exp_standart,
    
    [Parameter(HelpMessage = 'Do not hide the icon of collaborations in playlists.')]
    [switch]$hide_col_icon_off,
    
    [Parameter(HelpMessage = 'Do not enable the made for you button on the left sidebar.')]
    [switch]$made_for_you_off,
    
    [Parameter(HelpMessage = 'Do not enable enhance playlist.')]
    [switch]$enhance_playlist_off,
    
    [Parameter(HelpMessage = 'Do not enable enhance liked songs.')]
    [switch]$enhance_like_off,
    
    [Parameter(HelpMessage = 'Do not enable new discography on artist.')]
    [switch]$new_artist_pages_off,
    
    [Parameter(HelpMessage = 'Do not enable new lyrics.')]
    [switch]$new_lyrics_off,
    
    [Parameter(HelpMessage = 'Do not enable exception playlists from recommendations.')]
    [switch]$ignore_in_recommendations_off,

    [Parameter(HelpMessage = 'Enable audio equalizer for Desktop.')]
    [switch]$equalizer_off,
    
    [Parameter(HelpMessage = 'Enable showing a new and improved device picker UI.')]
    [switch]$device_new_off,

    [Parameter(HelpMessage = 'Enabled the new home structure and navigation.')]
    [switch]$enablenavalt,

    #[Parameter(HelpMessage = 'Connect unlock test.')]
    #[switch]$testconnect,
    
    [Parameter(HelpMessage = 'Select the desired language to use for installation. Default is the detected system language.')]
    [Alias('l')]
    [string]$Language
)

# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

function Format-LanguageCode {
    
    # Normalizes and confirms support of the selected language.
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [string]$LanguageCode
    )
    
    begin {
        $supportLanguages = @(
            'en', 'ru', 'it', 'tr', 'ka', 'pl'
        )
    }
    
    process {
        # Trim the language code down to two letter code.
        switch -Regex ($LanguageCode) {
            '^en' {
                $returnCode = 'en'
                break
            }
            '^(ru|py)' {
                $returnCode = 'ru'
                break
            }
            '^it' {
                $returnCode = 'it'
                break
            }
            '^tr' {
                $returnCode = 'tr'
                break
            }
            '^ka' {
                $returnCode = 'ka'
                break
            }
            '^pl' {
                $returnCode = 'pl'
                break
            }
            Default {
                $returnCode = $PSUICulture.Remove(2)
                break
            }
        }
        
        # Confirm that the language code is supported by this script.
        if ($returnCode -NotIn $supportLanguages) {
            # If the language code is not supported default to English.
            $returnCode = 'en'
        }
    }
    
    end {
        return $returnCode
    }
}

function Set-ScriptLanguageStrings {
    
    #Sets the language strings to be used.
    
    [CmdletBinding()]
    [OutputType([object])]
    param
    (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Two letter language code.')]
        [string]$LanguageCode
    )
    
    begin {
        # Define language strings.
        $langStringsEN = [PSCustomObject]@{
            Author          = "Patch author:"
            Author2         = "@Amd64fox"
            Incorrect       = "Oops, an incorrect value,"
            Incorrect2      = "enter again through "
            Download        = "Error downloading"
            Download2       = "Will re-request in 5 seconds..."
            Download3       = "Error again"
            Download4       = "Check your network settings and run the installation again"
            Download5       = "Downloading Spotify"
            StopScrpit      = "Script is stopped"
            MsSpoti         = "The Microsoft Store version of Spotify has been detected which is not supported"
            MsSpoti2        = "Uninstall Spotify Windows Store edition [Y/N]"
            MsSpoti3        = "Automatic uninstalling Spotify MS..."
            MsSpoti4        = "Uninstalling Spotify MS..."
            Prem            = "Modification for premium account..."
            OldV            = "Found outdated version of Spotify"
            OldV2           = "Your Spotify {0} version is outdated, it is recommended to upgrade to {1}"
            OldV3           = "Want to update ? [Y/N]"
            AutoUpd         = "Automatic update to the recommended version"
            DelOrOver       = "Do you want to uninstall the current version of {0} or install over it? Y [Uninstall] / N [Install Over]"
            DelOld          = "Uninstalling old Spotify..."
            NewV            = "Unsupported version of Spotify found"
            NewV2           = "Your Spotify {0} version hasn't been tested yet, currently it's a stable {1} version"
            NewV3           = "Do you want to continue with {0} version (errors possible) ? [Y/N]"
            Recom           = "Do you want to install the recommended {0} version ? [Y/N]"
            DelNew          = "Uninstalling an untested Spotify..."
            DownSpoti       = "Downloading and installing Spotify"
            DownSpoti2      = "Please wait..."
            PodcatsOff      = "Off Podcasts"
            PodcastsOn      = "On Podcasts"
            PodcatsSelect   = "Do you want to disable podcasts from the main page? [Y/N]"
            DowngradeNote   = "It is recommended to block because there was a downgrade of Spotify"
            UpdBlock        = "Spotify updates blocked"
            UpdUnblock      = "Spotify updates are not blocked"
            UpdSelect       = "Want to block Spotify updates? [Y/N]"
            CacheOn         = "Clear cache enabled ({0})"
            CacheOff        = "Clearing the cache is not enabled"
            CacheSelect     = "Want to set up automatic cache cleanup? [Y/N]"
            CacheDays       = "Cache older: XX days to be cleared "
            CacheDays2      = "Enter the number of days from 1 to 100"
            NoVariable      = "Didn't find variable"
            NoVariable2     = "in xpui.js"
            NoVariable3     = "in licenses.html"
            NoVariable4     = "in html"
            ModSpoti        = "Patching Spotify..."
            Error           = "Error"
            FileLocBroken   = "Location of Spotify files is broken, uninstall the client and run the script again"
            Spicetify       = "Spicetify detected"
            NoRestore       = "SpotX has already been installed, but files to recover xpui.js.bak and xpui.css.bak not found. `nPlease uninstall Spotify client and run Install.bat again"
            ExpSpotify      = "Experimental features operated by Spotify"
            ExpStandart     = "Experimental features of SpotX are not included"
            NoRestore2      = "SpotX has already been installed, xpui.bak not found. `nPlease uninstall Spotify client and run Install.bat again"
            UpdateBlocked   = "Spotify updates are already blocked"
            UpdateError     = "Failed to block updates"
            NoSpotifyExe    = "Could not find Spotify.exe"
            InstallComplete = "installation completed"
            HostInfo        = "Unwanted URLs found in hosts file"
            HostBak         = "Backing up hosts.bak..."
            HostDel         = "Trying to remove unwanted URLs from the original hosts file..."
            HostError       = "Something went wrong while editing the hosts file, edit it manually or run the script as administrator"
        }
        
        $langStringsRU = [PSCustomObject]@{
            Author          = "Автор патча:"
            Author2         = "@Amd64fox"
            Incorrect       = "Ой, некорректное значение,"
            Incorrect2      = "повторите ввод через"
            Download        = "Ошибка загрузки"
            Download2       = "Повторный запрос через 5 секунд..."
            Download3       = "Опять ошибка"
            Download4       = "Проверьте настройки вашей сети и снова запустите установку"
            Download5       = "Загрузка Spotify"
            StopScrpit      = "Cкрипт остановлен"
            MsSpoti         = "Обнаружена версия Spotify из Microsoft Store, которая не поддерживается"
            MsSpoti2        = "Хотите удалить Spotify Microsoft Store ? [Y/N]"
            MsSpoti3        = "Автоматическое удаление Spotify MS..."
            MsSpoti4        = "Удаление Spotify MS..."
            Prem            = "Модификация для премиум аккаунта..."
            OldV            = "Найдена устаревшая версия Spotify"
            OldV2           = "Ваша версия Spotify {0} устарела, рекомендуется обновиться до {1}"
            OldV3           = "Обновить ? [Y/N]"
            AutoUpd         = "Автоматическое обновление до рекомендуемой версии"
            DelOrOver       = "Вы хотите удалить текущую версию {0} или установить поверх нее? Y [Удалить] / N [Поверх]"
            DelOld          = "Удаление устаревшего Spotify..."
            NewV            = "Найдена неподдерживаемая версия Spotify"
            NewV2           = "Ваша версия Spotify {0} еще не тестировалась, стабильная версия сейчас {1}"
            NewV3           = "Хотите продолжить с {0} (возможны ошибки) ? [Y/N]"
            Recom           = "Хотите установить рекомендуемую {0} версию ? [Y/N]"
            DelNew          = "Удаление неподдерживаемого Spotify..."
            DownSpoti       = "Загружаю и устанавливаю Spotify"
            DownSpoti2      = "Пожалуйста подождите..."
            PodcatsOff      = "Подкасты отключены"
            PodcastsOn      = "Подкасты не отключены"
            PodcatsSelect   = "Хотите отключить подкасты c главной страницы ? [Y/N]"
            DowngradeNote   = "Рекомендуется заблокировать т.к. было понижение версии Spotify"
            UpdBlock        = "Обновления Spotify заблокированы"
            UpdUnblock      = "Обновления Spotify не заблокированы"
            UpdSelect       = "Хотите заблокировать обновления Spotify ? [Y/N]"
            CacheOn         = "Очистка кеша включена ({0})"
            CacheOff        = "Очистка кеша не включена"
            CacheSelect     = "Хотите установить автоматическую очистку кеша ? [Y/N]"
            CacheDays       = "Кэш старше: XX дней будет очищен"
            CacheDays2      = "Пожалуйста, введите количество дней от 1 до 100"
            NoVariable      = "Не нашел переменную"
            NoVariable2     = "в xpui.js"
            NoVariable3     = "в licenses.html"
            NoVariable4     = "в html"
            NoVariable5     = "в ru.json"
            ModSpoti        = "Модифицирую Spotify..."
            Error           = "Ошибка"
            FileLocBroken   = "Расположение файлов Spotify нарушено, удалите клиент и снова запустите скрипт"
            Spicetify       = "Обнаружен Spicetify"
            NoRestore       = "SpotX уже был установлен, но файлы для восстановления xpui.js.bak и xpui.css.bak не найдены. `nУдалите клиент Spotify и снова запустите Install.bat"
            ExpSpotify      = "Экспериментальные функции управляются Spotify"
            ExpStandart     = "Экспериментальные функции SpotX не включены"
            NoRestore2      = "SpotX уже был установлен, но файл для восстановления xpui.bak не найден. `nУдалите клиент Spotify и снова запустите Install.bat"
            UpdateBlocked   = "Обновления Spotify уже заблокированы"
            UpdateError     = "Не удалось заблокировать обновления"
            NoSpotifyExe    = "Spotify.exe не найден"
            InstallComplete = "Установка завершена"
            HostInfo        = "В файле hosts найдены нежелательные Url-адреса"
            HostBak         = "Создаю резервную копию hosts.bak..."
            HostDel         = "Попытка удалить нежелательные Url-адреса из оригинального файла hosts..."
            HostError       = "Что-то пошло не так при редактировании файла hosts, отредактируйте его вручную или запустите скрипт от администратора"
        }

        $langStringsIT = [PSCustomObject]@{
            Author          = "Autore patch:"
            Author2         = "@Amd64fox"
            TranslationBy   = "Autore traduzione:"
            TranslationBy2  = "@Francescoaracu"
            Incorrect       = "Ops! Valore sbagliato,"
            Incorrect2      = "Inserisci di nuovo"
            Download        = "Errore nel download"
            Download2       = "Nuova richiesta in 5 secondi..."
            Download3       = "Nuovo errore"
            Download4       = "Verifica le tue impostazioni di rete e fai partire di nuovo l'installazione"
            Download5       = "Scarico Spotify"
            StopScrpit      = "Lo script è stato fermato"
            MsSpoti         = "Trovata versione del Microsoft Store di Spotify, che non è supportata"
            MsSpoti2        = "Disinstalla la versione Microsoft Store di Spotify [Y/N]"
            MsSpoti3        = "Disinstallazione automatica Spotify MS..."
            MsSpoti4        = "Disinstallo Spotify MS..."
            Prem            = "Modifica per account premium..."
            OldV            = "Trovata vecchia versione di Spotify"
            OldV2           = "La tua versione di Spotify {0} è vecchia, è consigliato aggiornare alla versione {1}"
            OldV3           = "Vuoi aggiornare? [Y/N]"
            AutoUpd         = "Aggiornamento automatico alla versione consigliata"
            DelOrOver       = "Vuoi disinstallare la versione installata {0} o sovrascriverla? Y [Disinstalla] / N [Sovrascrivi]"
            DelOld          = "Disinstallo vecchio Spotify..."
            NewV            = "Trovata versione di Spotify non supportata"
            NewV2           = "La tua versione {0} di Spotify non è stata ancora testata, al momento la {1} è stabile"
            NewV3           = "Vuoi continuare a installare la versione {0} (possibili errori)? [Y/N]"
            Recom           = "Vuoi installare la versione consigliata {0}? [Y/N]"
            DelNew          = "Disinstallo una versione non testata di Spotify..."
            DownSpoti       = "Scarico e installo Spotify"
            DownSpoti2      = "Attendi..."
            PodcatsOff      = "Podcasts OFF"
            PodcastsOn      = "Podcasts ON"
            PodcatsSelect   = "Vuoi rimuovere i podcast dalla home? [Y/N]"
            DowngradeNote   = "Si consiglia il blocco degli aggiornamenti perché è stato eseguito un downgrade di Spotify"
            UpdBlock        = "Aggiornamenti di Spotify bloccati"
            UpdUnblock      = "Aggiornamenti di Spotify non bloccati"
            UpdSelect       = "Vuoi bloccare gli aggiornamenti automatici di Spotify? [Y/N]"
            CacheOn         = "Attivata la cancellazione automatica della cache ({0})"
            CacheOff        = "Cancellazione automatica della cache non attiva"
            CacheSelect     = "Vuoi attivare la cancellazione automatica della cache? [Y/N]"
            CacheDays       = "Verrà cancellata la cache più vecchia di XX giorni"
            CacheDays2      = "Inserisci il numero dei giorni da 1 a 100"
            NoVariable      = "Variabile non trovata"
            NoVariable2     = "in xpui.js"
            NoVariable3     = "in licenses.html"
            NoVariable4     = "in html"
            ModSpoti        = "Patching Spotify..."
            Error           = "Errore"
            FileLocBroken   = "Il percorso dei file di Spotify non è stato trovato, disinstalla Spotify e fai ripartire lo script"
            Spicetify       = "Rilevato Spicetify"
            NoRestore       = "SpotX è già stato installato, ma file da recuperare xpui.js.bak e xpui.css.bak non trovati. `nPer favore, disinstalla Spotify e riapri il file Install.bat"
            ExpSpotify      = "Features sperimentali attivate da Spotify"
            ExpStandart     = "Features sperimentali di SpotX non incluse"
            NoRestore2      = "SpotX è già stato installato, xpui.bak non trovato. `nPer favore, disinstalla Spotify e riapri il file Install.bat"
            UpdateBlocked   = "Gli aggiornamenti automatici di Spotify sono già stati bloccati"
            UpdateError     = "Blocco degli aggiornamenti non riuscito"
            NoSpotifyExe    = "Spotify.exe non trovato"
            InstallComplete = "Installazione completata"
            HostInfo        = "Trovati URL non desiderati nel file hosts"
            HostBak         = "Backup di hosts.bak in corso..."
            HostDel         = "Provo a rimuovere URL non desiderati dal file hosts originale..."
            HostError       = "Qualcosa è andato storto provando a modificare il file hosts, modificalo manualmente o fai partire lo script come amministratore"
        }

        $langStringsTR = [PSCustomObject]@{
            Author          = "Yama yapımcısı:"
            Author2         = "@Amd64fox"
            TranslationBy   = "Tercüman:"
            TranslationBy2  = "@metezd"
            Incorrect       = "Eyvah, yanlış bir değer,"
            Incorrect2      = "tekrar girin "
            Download        = "İndirirken hata oluştu"
            Download2       = "5 saniye içinde tekrar talep edilecek..."
            Download3       = "Yine hata oluştu"
            Download4       = "Ağ ayarlarınızı kontrol edin ve kurulumu tekrar çalıştırın"
            Download5       = "Spotify indiriliyor"
            StopScrpit      = "Komut dosyası durduruldu"
            MsSpoti         = "Spotify'ın desteklenmeyen Microsoft Mağazası sürümü tespit edildi"
            MsSpoti2        = "Spotify Windows Mağazası sürümünü kaldır [Y/N]"
            MsSpoti3        = "Spotify MS otomatik olarak kaldırlıyor..."
            MsSpoti4        = "Spotify MS kaldırılıyor..."
            Prem            = "Premium hesap için modifikasyon ..."
            OldV            = "Spotify'ın eski bir sürümü bulundu"
            OldV2           = "Spotify {0} sürümü güncel değil, {1} sürümüne yükseltmeniz önerilir"
            OldV3           = "Güncelleme yapılsın mı? [Y/N]"
            AutoUpd         = "Önerilen sürüme otomatik olarak güncelle"
            DelOrOver       = "Mevcut {0} sürümünü kaldırmak mı yoksa üzerine yüklemek mi istiyorsunuz? Y [Kaldır] / N [Üzerine Yükle]"
            DelOld          = "Eski Spotify kaldırılıyor..."
            NewV            = "Desteklenmeyen Spotify sürümü bulundu"
            NewV2           = "Spotify {0} sürümü henüz test edilmedi, şu anda kararlı olan {1} sürümüdür"
            NewV3           = "{0} sürümü ile devam etmek istiyor musunuz (hatalar olabilir) ? [Y/N]"
            Recom           = "Önerilen {0} sürümünü yüklemek istiyor musunuz? [Y/N]"
            DelNew          = "Test edilmemiş Spotify kaldırılıyor..."
            DownSpoti       = "Spotify indiriliyor ve kuruluyor"
            DownSpoti2      = "Lütfen bekleyin..."
            PodcatsOff      = "Podcast'ler Kapalı"
            PodcastsOn      = "Podcast'ler Açık"
            PodcatsSelect   = "Podcast'leri ana sayfadan kaldırmak istiyor musunuz? [Y/N]"
            DowngradeNote   = "Spotify'da bir sürüm düşürme olduğu için engellemeniz önerilir"
            UpdBlock        = "Spotify güncellemeleri engellendi"
            UpdUnblock      = "Spotify güncellemeleri engellenmedi"
            UpdSelect       = "Spotify güncellemelerini engellemek ister misiniz? [Y/N]"
            CacheOn         = "Önbelleği temizleme etkin ({0})"
            CacheOff        = "Önbelleğin temizlenmesi etkin değil"
            CacheSelect     = "Otomatik önbellek temizlemeyi ayarlamak ister misiniz? [Y/N]"
            CacheDays       = "Daha eski olan önbellek: XX gün içinde temizlenecek "
            CacheDays2      = "Gün sayısını 1 ile 100 arasında girin"
            NoVariable      = "Değişken bulunamadı"
            NoVariable2     = "xpui.js içinde"
            NoVariable3     = "in licenses.html"
            NoVariable4     = "html içinde"
            ModSpoti        = "Spotify'a yama yapılıyor..."
            Error           = "Hata"
            FileLocBroken   = "Spotify dosyalarının konumu bozuk, istemciyi kaldırın ve kodu tekrar çalıştırın"
            Spicetify       = "Spicetify algılandı"
            NoRestore       = "SpotX zaten yüklenmiş, ancak xpui.js.bak ve xpui.css.bak dosyalarının bulunamadığı tespit edildi. `nLütfen Spotify istemcisini kaldırın ve Install.bat dosyasını tekrar çalıştırın"
            ExpSpotify      = "Spotify tarafından sunulan deneysel özellikler"
            ExpStandart     = "SpotX'in deneysel özellikleri dahil değildir"
            NoRestore2      = "SpotX zaten kurulmuş, xpui.bak dosyası bulunamadı. `nLütfen Spotify istemcisini kaldırın ve Install.bat dosyasını tekrar çalıştırın"
            UpdateBlocked   = "Spotify güncellemeleri zaten engellenmiş durumda"
            UpdateError     = "Güncellemeler engellenemedi"
            NoSpotifyExe    = "Spotify.exe bulunamadı"
            InstallComplete = "kurulum tamamlandı"
            HostInfo        = "Hosts dosyasında istenmeyen URL'ler bulundu"
            HostBak         = "hosts.bak dosyası yedekleniyor...."
            HostDel         = "Orijinal hosts dosyasından istenmeyen URL'ler kaldırılmaya çalışılıyor..."
            HostError       = "Hosts dosyasını düzenlerken bir şeyler ters gitti, elle düzenleyin veya kodu yönetici olarak çalıştırın"
        }

        $langStringsKA = [PSCustomObject]@{
            Author          = "პაჩის ავტორი:"
            Author2         = "@Amd64fox"
            TranslationBy   = "თარგმანის ავტორი:"
            TranslationBy2  = "@Naviamold1"
            Incorrect       = "უპს, არასწორი შენატანი,"
            Incorrect2      = "მაგრამ თავიდან სცადე"
            Download        = "შეცდომა ჩაწერის დროს"
            Download2       = "თავიდან ვცდი 5 წამში..."
            Download3       = "შეცდომა ისევ"
            Download4       = "შეამოწმეთ თქვენი კავშირი ქსელთან და თავიდან სცადე ინსტალაცია"
            Download5       = "Spotify იწერება"
            StopScrpit      = "სკრიპტი ჩერდება"
            MsSpoti         = "Microsoft Store-ის ვერსია მოიძებნა რომელიც არ არის მხარდაჯერილი" 
            MsSpoti2        = "წავშალოთ Spotify Microsoft Store-ის ვერსია [Y/N]"
            MsSpoti3        = "ავტუმატურად იშლება Spotify MS..."
            MsSpoti4        = "იშლება Spotify MS..."
            Prem            = "მოდიფიკაცია პრემიუმ აკკოუნტის..."
            OldV            = "მოიძებნა მოძველებული Spotify-ს ვერსია"
            OldV2           = "თქვენი Spotify-ს {0} ვერსია არის მოძველებული, რეკომენდურია მისი აპგრეიდობა ამ ვერსიაზე {1}"
            OldV3           = "გინდა განაახლოთ ? [Y/N]"
            AutoUpd         = "აუტომატიკური აპდაიტი რეკომენდებულ ვერსიაზე"
            DelOrOver       = "გინდა წაშალო ეხლანდელი ვერსია: {0} თუ თავიდან ჩაწერა? Y [წაშლა] / N [თავიდან ჩაწერა]"
            DelOld          = "ძველი Spotify იშლება..."
            NewV            = "არა მხარდაჯერილი Spotify-ს ვერსია არის მოწებნილი"
            NewV2           = "თქვენი Spotify-ს {0} ვერსია ჯერ არ არის დატესტილი, ამჟამად არის სტაბილური {1} ვერსია"
            NewV3           = "გინდათ რომ გააგრძელოთ {0} ვერსიაზე (შეცდომები შესაძლებელია) ? [Y/N]"
            Recom           = "გინდათ რო ჩაიწეროთ რეკომენდირებული {0} ვერსია ? [Y/N]"
            DelNew          = "იშლება არა ტესტირებულ Spotify..."
            DownSpoti       = "ვტვირთავთ და ვიწერთ Spotify-ს"
            DownSpoti2      = "გთხოვთ დაიცადოთ..."
            PodcatsOff      = "პოდკასტები გათიშული"
            PodcastsOn      = "პოდკასტები ჩართული"
            PodcatsSelect   = "გინდათ რომ გათიშოთ პოდკასტები მთავარ გვერდიდან? [Y/N]"
            DowngradeNote   = "რეკომენდირებული რომ დაბლოკოთ იმიტომ რომ იყო Spotify-ს დაქვეითება"
            UpdBlock        = "Spotify-ს განახლებები დაბლოკილია"
            UpdUnblock      = "Spotify-ს განახლებები არ არის დაბლოკილი"
            UpdSelect       = "გინდათ რომ დაბლოკოთ Spotify-ს განახლებები? [Y/N]"
            CacheOn         = "ქეშის გაწმენდა ჩართულია ({0})"
            CacheOff        = "ქეშის გაწმენდა არ არის ჩართული"
            CacheSelect     = "გინდათ რომ ჩართოთ ავტომატიკური ქეშის გაწმენდა? [Y/N]"
            CacheDays       = "ქეში უფრო ძველია: XX დღეზე რომ იყოს გაწმენდილი "
            CacheDays2      = "შეიყვანეთ the დღეების რაოდენობა 1-იდან 100-ამდე"
            NoVariable      = "ცვლადი არ არის მოძებნილი"
            NoVariable2     = "xpui.js -ში"
            NoVariable3     = "licenses.html -ში"
            NoVariable4     = "html =ში"
            ModSpoti        = "Spotify იკერვება..."
            Error           = "შეცდომა"
            FileLocBroken   = "Spotify ფაილების ლოკაცია არის გადეხილი, წაშალეთ კლიენტი და თავიდან გაუშვით სკრიპტი"
            Spicetify       = "Spicetify მოიზებნა"
            NoRestore       = "SpotX უკვეა ჩაწერილი, მაგრამ ფაილები xpui.js.bak და xpui.css.bak აღსადგენად ვერ მოიძებნა. `nგთხოვთ წაშალეთ Spotify-ის აპლიკაცია და თავიდან გაუშვით Install.bat"
            ExpSpotify      = "ექსპერიმენტული ფუნქციები, რომელსაც მართავს Spotify"
            ExpStandart     = "ექსპერიმენტული ფუნქციები SpotX არ მოითავსება"
            NoRestore2      = "SpotX უკვე დაინსტალირებულია, xpui.bak ვერ მოიძებნა. `nგთხოვთ, წაშალოთ Spotify აპლიკაცია და თავიდან გაუშვით Install.bat"
            UpdateBlocked   = "Spotify-ს განახლებები უკვე დაბლოკერიბული არიან"
            UpdateError     = "განახლებების დაბლოკვა ვერ მოხერხდა"
            NoSpotifyExe    = "Spotify.exe ვერ მოიძებნა"
            InstallComplete = "ინსტალაცია დასრულდა"
            HostInfo        = "არასასურველი URL-ები ნაპოვნი მასპინძელის ფაილში"
            HostBak         = "იქმნება hosts.bak-ის სარევეზნო ასლი..."
            HostDel         = "ვცდილობთ რომ ამოვიღოთ არასასურველი URL-ები ორიგინალური მასპინძელის ფაილიდან..."
            HostError       = "რაღაც შეცდომა მოხდა მასპინძელის ფაილის რედაქტირებისას, დაარედაქტირეთ ის ხელით ან გაუშვით სკრიპტი ადმინისტრატორის სახით"
        }

        $langStringsPL = [PSCustomObject]@{
            Author          = "Patch author:"
            Author2         = "@Amd64fox"
            TranslationBy   = "Translation author:"
            TranslationBy2  = "@Nokxixr"
            Incorrect       = "Oops, niewłaściwa wartość,"
            Incorrect2      = "Wejdź ponownie przez "
            Download        = "Błąd pobierania"
            Download2       = "Prośbę ponowię za 5 sekund..."
            Download3       = "Ponowny Błąd"
            Download4       = "Sprawdź swoje połączenie z siecią i spróbuj ponownie"
            Download5       = "Pobieranie Spotify"
            StopScrpit      = "Skrypt wstrzymany"
            MsSpoti         = "Wersja Microsoft Store Spotify została wykryta i nie jest wspierana"
            MsSpoti2        = "Odinstalować wersję od Spotify Windows Store? [Y/N]"
            MsSpoti3        = "Automatyczne odinstalowywanie Spotify MS..."
            MsSpoti4        = "Odinstalowywanie Spotify MS..."
            Prem            = "Modyfikacja dla konta premium..."
            OldV            = "Znaleziono nieaktualną wersję Spotify"
            OldV2           = "Twoja wersja Spotify {0} jest nieaktualna, zalecana jest aktualizacja do {1}"
            OldV3           = "Czy chcesz ją pobrać? [Y/N]"
            AutoUpd         = "Automatyczna aktualizacja do zalecanej wersji"
            DelOrOver       = "Chcesz odinstalować aktualną wersję {0}, czy pobrać nową? Y [Odinstaluj] / N [Pobierz Nowa]"
            DelOld          = "Odinstalowywanie przedawnionego Spotify..."
            NewV            = "Wykryto niewspieraną wersję Spotify"
            NewV2           = "Twoja wersja {0} nie została jeszcze przetestowana, obecna stabilna jest wersja {1} "
            NewV3           = "Czy chcesz kontynuować z wersją {0} (możliwe błędy) ? [Y/N]"
            Recom           = "Czy chcesz pobrać zalecaną, {0} wersję ? [Y/N]"
            DelNew          = "Odinstalowywanie niesprawdzonego Spotify..."
            DownSpoti       = "Pobieranie i instalowanie Spotify"
            DownSpoti2      = "Proszę czekać..."
            PodcatsOff      = "Wyłączanie Podcastsów"
            PodcastsOn      = "Włączanie Podcastsów"
            PodcatsSelect   = "Czy chcesz wyłączyć podcasty ze strony głównej?? [Y/N]"
            DowngradeNote   = "Zalecane jest zablokowanie, ponieważ nastąpiło obniżenie wartości dla Spotify"
            UpdBlock        = "Aktualizacje Spotify zablokowane"
            UpdUnblock      = "Aktualizacje Spotify nie są zablokowane"
            UpdSelect       = "Czy chcesz zablokować aktualizacje dla Spotify? [Y/N]"
            CacheOn         = "Usuwanie plików cache ({0})"
            CacheOff        = "Czyszczenie plików cache jest wyłączone"
            CacheSelect     = "Chcesz ustawić automatyczne czyszczenie plików cache? [Y/N]"
            CacheDays       = "Czyszczenie co: XX dni"
            CacheDays2      = "Wybierz co ile dni ma nastąpić czyszczenie od 1 to 100 do"
            NoVariable      = "Nieznaleziono wartości"
            NoVariable2     = "w xpui.js"
            NoVariable3     = "w licenses.html"
            NoVariable4     = "w html"
            ModSpoti        = "Patchowanie Spotify..."
            Error           = "Błąd"
            FileLocBroken   = "Lokalizacje plików spotify są zepsute, odinstaluj klienta i uruchom ponownie skrypt"
            Spicetify       = "Spicetify wykryty"
            NoRestore       = "SpotX został zainstalowany, jednak pliki do odzyskania xpui.js.bak i xpui.css.bak zostały nieznalezione. `nProszę odinstalować klienta i uruchomić Install.bat ponownie"
            ExpSpotify      = "Eksperymentalne funkcje obsługiwane przez Spotify"
            ExpStandart     = "Eksperymentalne funkcje SpotX nie są uwzględnione"
            NoRestore2      = "SpotX został pobrany, xpui.bak nie znaleziony. `nProszę odinstalować klienta Spotify i uruchomić Install.bat ponownie"
            UpdateBlocked   = "Spotify aktualizacje są już zablokowane"
            UpdateError     = "Nie udało się zablokować aktualizacji"
            NoSpotifyExe    = "Nie można znaleźć Spotify.exe"
            InstallComplete = "Instalacja zakończona"
            HostInfo        = "Niepożądane adresy URL znalezione w plikach hosts"
            HostBak         = "Tworzenie kopii zapasowych hosts.bak..."
            HostDel         = "Próba usunięcia niechcianych adresów URL z oryginalnego pliku hosts..."
            HostError       = "Coś poszło nie tak podczas edycji pliku hosts, edytuj go ręcznie lub uruchom skrypt jako administrator"
        }
    }
    
    process {
        # Assign language strings.
        switch ($LangCode) {
            'en' {
                $langStrings = $langStringsEN
                break
            }
            'ru' {
                $langStrings = $langStringsRU
                break
            }
            'it' {
                $langStrings = $langStringsIT
                break
            }
            'tr' {
                $langStrings = $langStringsTR
                break
            }
            'ka' {
                $langStrings = $langStringsKA
                break
            }
            'pl' {
                $langStrings = $langStringsPL
                break
            }
            Default {
                # Default to English if unable to find a match.
                $langStrings = $langStringsEN
                break
            }
        }
    }
    end {
        return $langStrings
    }
}

# Set language code for script.
$langCode = Format-LanguageCode -LanguageCode $Language

# Set script language strings.
$lang = Set-ScriptLanguageStrings -LanguageCode $langCode

# Set variable 'ru'.
if ($langCode -eq 'ru') { $ru = $true }
# Set variable 'add transl line'.
if ($langCode -match '^(it|tr|ka|pl)') { $line = $true }

# Automatic length of stars
$au = ($lang).Author.Length + ($lang).Author2.Length
$by = ($lang).TranslationBy.Length + ($lang).TranslationBy2.Length
if ($au -gt $by ) { $long = $au + 1 } else { $long = $by + 1 } 
$st = ""
$star = $st.PadLeft($long, '*')

Write-Host $star
Write-Host ($lang).Author"" -NoNewline
Write-Host ($lang).Author2 -ForegroundColor DarkYellow
if (!($line)) { Write-Host $star`n }
if ($line) {
    Write-Host ($lang).TranslationBy"" -NoNewline
    Write-Host ($lang).TranslationBy2 -ForegroundColor DarkYellow
    Write-Host $star`n
}

# Sending a statistical web query to cutt.ly
$ErrorActionPreference = 'SilentlyContinue'
$cutt_url = "https://cutt.ly/DK8UQub"
try {  
    Invoke-WebRequest -Uri $cutt_url | Out-Null
}
catch {
    Start-Sleep -Milliseconds 2300
    try { 
        Invoke-WebRequest -Uri $cutt_url | Out-Null
    }
    catch { }
}

$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyDirectory2 = "$env:LOCALAPPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$exe_bak = "$spotifyDirectory\Spotify.bak"
$chrome_elf = "$spotifyDirectory\chrome_elf.dll"
$chrome_elf_bak = "$spotifyDirectory\chrome_elf_bak.dll"
$cache_folder = "$env:APPDATA\Spotify\cache"
$spotifyUninstall = "$env:TEMP\SpotifyUninstall.exe"
$upgrade_client = $false

function incorrectValue {

    Write-Host ($lang).Incorrect"" -ForegroundColor Red -NoNewline
    Write-Host ($lang).Incorrect2"" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host "3" -NoNewline 
    Start-Sleep -Milliseconds 1000
    Write-Host " 2" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host " 1"
    Start-Sleep -Milliseconds 1000     
    Clear-Host
} 

function Check_verison_clients($param2) {

    # checking the recommended version for spotx
    if ($param2 -eq "online") {
        $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
        $readme = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/amd64fox/SpotX/main/README.md
        $v = $readme.RawContent | Select-String "Recommended official version \[\d+\.\d+\.\d+\.\d+\]" -AllMatches
        $ver = $v.Matches.Value
        $ver = $ver -replace 'Recommended official version \[(\d+\.\d+\.\d+\.\d+)\]', '$1'
        return $ver
    }
    # Check version Spotify offline
    if ($param2 -eq "offline") {
        $check_offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion
        return $check_offline
    }
    # Check version Spotify.bak
    if ($param2 -eq "Spotify.bak") {
        $check_offline_bak = (Get-Item $exe_bak).VersionInfo.FileVersion
        return $check_offline_bak
    }
}
function unlockFolder {

    $ErrorActionPreference = 'SilentlyContinue'
    $block_File_update = "$env:LOCALAPPDATA\Spotify\Update"
    $Check_folder = Get-ItemProperty -Path $block_File_update | Select-Object Attributes 
    $folder_update_access = Get-Acl $block_File_update

    # Check folder Update if it exists
    if ($Check_folder -match '\bDirectory\b') {  

        # If the rights of the Update folder are blocked, then unblock 
        if ($folder_update_access.AccessToString -match 'Deny') {
                ($ACL = Get-Acl $block_File_update).access | ForEach-Object {
                $Users = $_.IdentityReference 
                $ACL.PurgeAccessRules($Users) }
            $ACL | Set-Acl $block_File_update
        }
    }
}     

function downloadScripts($param1) {

    $webClient = New-Object -TypeName System.Net.WebClient

    if ($param1 -eq "Desktop") {
        Import-Module BitsTransfer
        
        $ver = Check_verison_clients -param2 "online"
        $l = "$PWD\links.tsv"
        $old = [IO.File]::ReadAllText($l)
        $links = $old -match "https:\/\/upgrade.scdn.co\/upgrade\/client\/win32-x86\/spotify_installer-$ver\.g[0-9a-f]{8}-[0-9]{1,3}\.exe" 
        $links = $Matches.Values
    }
    if ($ru -and $param1 -eq "cache-spotify") {
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify_ru.ps1"
    }
    if (!($ru) -and $param1 -eq "cache-spotify" ) { 
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify.ps1"
    }
    
    $web_Url_prev = "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip", $links, `
        $links2, "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/hide_window.vbs", `
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/run_ps.bat", "https://docs.google.com/spreadsheets/d/e/2PACX-1vSFN2hWu4UO-ZWyVe8wlP9c0JsrduA49xBnRmSLOt8SWaOfIpCwjDLKXMTWJQ5aKj3WakQv6-Hnv9rz/pub?gid=0&single=true&output=tsv"

    $local_Url_prev = "$PWD\chrome_elf.zip", "$PWD\SpotifySetup.exe", "$cache_folder\cache_spotify.ps1", "$cache_folder\hide_window.vbs", "$cache_folder\run_ps.bat", "$PWD\links.tsv"
    $web_name_file_prev = "chrome_elf.zip", "SpotifySetup.exe", "cache_spotify.ps1", "hide_window.vbs", "run_ps.bat", "links.tsv"

    switch ( $param1 ) {
        "BTS" { $web_Url = $web_Url_prev[0]; $local_Url = $local_Url_prev[0]; $web_name_file = $web_name_file_prev[0] }
        "Desktop" { $web_Url = $web_Url_prev[1]; $local_Url = $local_Url_prev[1]; $web_name_file = $web_name_file_prev[1] }
        "cache-spotify" { $web_Url = $web_Url_prev[2]; $local_Url = $local_Url_prev[2]; $web_name_file = $web_name_file_prev[2] }
        "hide_window" { $web_Url = $web_Url_prev[3]; $local_Url = $local_Url_prev[3]; $web_name_file = $web_name_file_prev[3] }
        "run_ps" { $web_Url = $web_Url_prev[4]; $local_Url = $local_Url_prev[4]; $web_name_file = $web_name_file_prev[4] } 
        "links.tsv" { $web_Url = $web_Url_prev[5]; $local_Url = $local_Url_prev[5]; $web_name_file = $web_name_file_prev[5] }
    }

    if ($param1 -eq "Desktop") {
        try { if (curl.exe -V) { $curl_check = $true } }
        catch { $curl_check = $false }
        $vernew = Check_verison_clients -param2 "online"
    }
    try { 
        if ($param1 -eq "Desktop" -and $curl_check) {
            $stcode = curl.exe -I -s $web_Url
            if (!($stcode -match "200 OK")) { throw ($lang).Download6 }
            curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
        }
        if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$vernew "
        }
        if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            $webClient.DownloadFile($web_Url, $local_Url) 
        }
        if ($param1 -ne "Desktop") {
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            $webClient.DownloadFile($web_Url, $local_Url) 
        }
    }

    catch {
        Write-Host ""
        Write-Host ($lang).Download $web_name_file -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host ($lang).Download2`n
        Start-Sleep -Milliseconds 5000 
        try { 

            if ($param1 -eq "Desktop" -and $curl_check) {
                $stcode = curl.exe -I -s $web_Url
                if (!($stcode -match "200 OK")) { throw ($lang).Download6 }
                curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
            }
            if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$vernew "
            }
            if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                $webClient.DownloadFile($web_Url, $local_Url) 
            }
            if ($param1 -ne "Desktop") {
                $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
                $webClient.DownloadFile($web_Url, $local_Url) 
            }

        }
        
        catch {
            Write-Host ($lang).Download3 -ForegroundColor RED
            $Error[0].Exception
            Write-Host ""
            Write-Host ($lang).Download4`n
            ($lang).StopScrpit
            $tempDirectory = $PWD
            Pop-Location
            Start-Sleep -Milliseconds 200
            Remove-Item -Recurse -LiteralPath $tempDirectory
            Pause
            Exit
        }
    }
} 

function DesktopFolder {

    # If the default Dekstop folder does not exist, then try to find it through the registry.
    
    $ErrorActionPreference = 'SilentlyContinue' 
    if (Test-Path "$env:USERPROFILE\Desktop") {  
        $desktop_folder = "$env:USERPROFILE\Desktop"  
    }

    $regedit_desktop_folder = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\"
    $regedit_desktop = $regedit_desktop_folder.'{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}'
 
    if (!(Test-Path "$env:USERPROFILE\Desktop")) {
        $desktop_folder = $regedit_desktop
    }
    return $desktop_folder
}

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Stop-Process -Name Spotify

if ($PSVersionTable.PSVersion.major -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# Check version Windows
$win_os = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"

if ($win11 -or $win10 -or $win8_1 -or $win8) {

    # Remove Spotify Windows Store If Any
    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host ($lang).MsSpoti`n
        
        if (!($confirm_uninstall_ms_spoti)) {
            do {
                $ch = Read-Host -Prompt ($lang).MsSpoti2
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
    
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_uninstall_ms_spoti) { $ch = 'y' }
        if ($ch -eq 'y') {      
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            if ($confirm_uninstall_ms_spoti) { Write-Host ($lang).MsSpoti3`n }
            if (!($confirm_uninstall_ms_spoti)) { Write-Host ($lang).MsSpoti4`n }
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        if ($ch -eq 'n') {
            Read-Host ($lang).StopScrpit 
            Pause
            Exit
        }
    }
}

# Attempt to fix the hosts file
$pathHosts = "$Env:windir\System32\Drivers\Etc\hosts"
$pathHosts_bak = "$Env:windir\System32\Drivers\Etc\hosts.bak"
$ErrorActionPreference = 'SilentlyContinue'
$testHosts = Test-Path -Path $pathHosts

if ($testHosts) {
    $hosts = Get-Content -Path $pathHosts

    if ($hosts -match '^[^\#|].+scdn.+|^[^\#|].+spotify.+') {
        Write-Host ($lang).HostInfo
        Write-Host ($lang).HostBak
        copy-Item $pathHosts $pathHosts_bak
        Write-Host ($lang).HostDel`n       

        try {
            $hosts = $hosts -replace '^[^\#|].+scdn.+|^[^\#|].+spotify.+', ''
            Set-Content -Path $pathHosts -Value $hosts -Force
            $hosts | Where-Object { $_.trim() -ne "" } | Set-Content -Path $pathHosts -Force
        }
        catch {
            Write-Host ($lang).HostError`n -ForegroundColor Red
        }
    }
}

# Unique directory name based on time
Push-Location -LiteralPath $env:TEMP
New-Item -Type Directory -Name "SpotX_Temp-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" | Convert-Path | Set-Location

if ($premium) {
    Write-Host ($lang).Prem`n
}
if (!($premium)) {
    downloadScripts -param1 "BTS"
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
    [System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
    $zip.Dispose()
}
downloadScripts -param1 "links.tsv"


$online = Check_verison_clients -param2 "online"

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {

    $offline = Check_verison_clients -param2 "offline"

    if ($online -gt $offline) {
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host ($lang).OldV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                Write-Host (($lang).OldV2 -f $offline, $online)
                $ch = Read-Host -Prompt ($lang).OldV3
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
            $ch = 'y' 
            Write-Host ($lang).AutoUpd`n
        }
        if ($ch -eq 'y') { 
            $upgrade_client = $true 

            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
                    Write-Host ""
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_unistall) { $ch = 'y' }
            if ($confirm_spoti_recomended_over) { $ch = 'n' }
            if ($ch -eq 'y') {
                Write-Host ($lang).DelOld`n 
                unlockFolder
                cmd /c $spotifyExecutable /UNINSTALL /SILENT
                wait-process -name SpotifyUninstall
                Start-Sleep -Milliseconds 200
                if (Test-Path $spotifyDirectory) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory }
                if (Test-Path $spotifyDirectory2) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory2 }
                if (Test-Path $spotifyUninstall ) { Remove-Item -Recurse -Force -LiteralPath $spotifyUninstall }
            }
            if ($ch -eq 'n') { $ch = $null }
        }
        if ($ch -eq 'n') { 
            $downgrading = $true
        }
    }

    if ($online -lt $offline) {

        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host ($lang).NewV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                Write-Host (($lang).NewV2 -f $offline, $online)
                $ch = Read-Host -Prompt (($lang).NewV3 -f $offline)
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { $ch = 'n' }
        if ($ch -eq 'y') { $upgrade_client = $false }
        if ($ch -eq 'n') {
            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).Recom -f $online)
                    Write-Host ""
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
                $ch = 'y' 
                Write-Host ($lang).AutoUpd`n
            }
            if ($ch -eq 'y') {
                $upgrade_client = $true
                $downgrading = $true
                if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                    do {
                        $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
                        Write-Host ""
                        if (!($ch -eq 'n' -or $ch -eq 'y')) {
                            incorrectValue
                        }
                    }
                    while ($ch -notmatch '^y$|^n$')
                }
                if ($confirm_spoti_recomended_unistall) { $ch = 'y' }
                if ($confirm_spoti_recomended_over) { $ch = 'n' }
                if ($ch -eq 'y') {
                    Write-Host ($lang).DelNew`n
                    unlockFolder
                    cmd /c $spotifyExecutable /UNINSTALL /SILENT
                    wait-process -name SpotifyUninstall
                    Start-Sleep -Milliseconds 200
                    if (Test-Path $spotifyDirectory) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory }
                    if (Test-Path $spotifyDirectory2) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory2 }
                    if (Test-Path $spotifyUninstall ) { Remove-Item -Recurse -Force -LiteralPath $spotifyUninstall }
                }
                if ($ch -eq 'n') { $ch = $null }
            }

            if ($ch -eq 'n') {
                Write-Host ($lang).StopScrpit
                $tempDirectory = $PWD
                Pop-Location
                Start-Sleep -Milliseconds 200
                Remove-Item -Recurse -LiteralPath $tempDirectory 
                Pause
                Exit
            }
        }
    }
}
# If there is no client or it is outdated, then install
if (-not $spotifyInstalled -or $upgrade_client) {

    Write-Host ($lang).DownSpoti"" -NoNewline
    Write-Host  $online -ForegroundColor Green
    Write-Host ($lang).DownSpoti2`n
    
    # Delete old version files of Spotify before installing, leave only profile files
    $ErrorActionPreference = 'SilentlyContinue'
    Stop-Process -Name Spotify 
    Start-Sleep -Milliseconds 600
    unlockFolder
    Start-Sleep -Milliseconds 200
    Get-ChildItem $spotifyDirectory -Exclude 'Users', 'prefs', 'cache' | Remove-Item -Recurse -Force 
    Start-Sleep -Milliseconds 200

    # Client download
    downloadScripts -param1 "Desktop"
    Write-Host ""

    Start-Sleep -Milliseconds 200

    # Client installation
    Start-Process -FilePath explorer.exe -ArgumentList $PWD\SpotifySetup.exe
    while (-not (get-process | Where-Object { $_.ProcessName -eq 'SpotifySetup' })) {}
    wait-process -name SpotifySetup


    wait-process -name SpotifySetup
    Stop-Process -Name Spotify 

}

# Delete the leveldb folder (Fixes bug with incorrect experimental features for some accounts)
$leveldb = (Test-Path -LiteralPath "$spotifyDirectory2\Browser\Local Storage\leveldb")

if ($leveldb) {
    $ErrorActionPreference = 'SilentlyContinue'
    remove-item "$spotifyDirectory2\Browser\Local Storage\leveldb" -Recurse -Force
}

# Create backup chrome_elf.dll
if (!(Test-Path -LiteralPath $chrome_elf_bak) -and !($premium)) {
    Move-Item $chrome_elf $chrome_elf_bak 
}

$ch = $null

if ($podcasts_off) { 
    Write-Host ($lang).PodcatsOff`n 
    $ch = 'y'
}
if ($podcasts_on) {
    Write-Host ($lang).PodcastsOn`n
    $ch = 'n'
}
if (!($podcasts_off) -and !($podcasts_on)) {

    do {
        $ch = Read-Host -Prompt ($lang).PodcatsSelect
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $podcast_off = $true }

$ch = $null

if ($downgrading) { $upd = "`n" + [string]($lang).DowngradeNote }

else { $upd = "" }

if ($block_update_on) { 
    Write-Host ($lang).UpdBlock`n
    $ch = 'y'
}
if ($block_update_off) {
    Write-Host ($lang).UpdUnblock`n
    $ch = 'n'
}
if (!($block_update_on) -and !($block_update_off)) {
    do {
        $text_upd = [string]($lang).UpdSelect + $upd
        $ch = Read-Host -Prompt $text_upd
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue } 
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $block_update = $true }

if ($ch -eq 'n') {
    $ErrorActionPreference = 'SilentlyContinue'
    $exe_onl_fn = Check_verison_clients -param2 "offline"
    $exe_bak_fn = Check_verison_clients -param2 'Spotify.bak'
    if ((Test-Path -LiteralPath $exe_bak) -and $exe_onl_fn -eq $exe_bak_fn) {
        Remove-Item $spotifyExecutable -Recurse -Force
        Rename-Item $exe_bak $spotifyExecutable
    }
}

$ch = $null

if ($cache_on) { 
    Write-Host (($lang).CacheOn -f $number_days)`n 
    $cache_install = $true
}
if ($cache_off) { 
    Write-Host ($lang).CacheOff`n
    $ErrorActionPreference = 'SilentlyContinue'
    $desktop_folder = DesktopFolder
    if (Test-Path -LiteralPath $cache_folder) {
        remove-item $cache_folder -Recurse -Force
        remove-item $desktop_folder\Spotify.lnk -Recurse -Force
    } 
}
if (!($cache_on) -and !($cache_off)) {

    do {
        $ch = Read-Host -Prompt ($lang).CacheSelect
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')

    if ($ch -eq 'y') {
        $cache_install = $true 

        do {
            Write-Host ($lang).CacheDays
            $ch = Read-Host -Prompt ($lang).CacheDays2
            Write-Host ""
            if (!($ch -match "^[1-9][0-9]?$|^100$")) { incorrectValue }
        }
        while ($ch -notmatch '^[1-9][0-9]?$|^100$')

        if ($ch -match "^[1-9][0-9]?$|^100$") { $number_days = $ch }
    }
    if ($ch -eq 'n') {
        $ErrorActionPreference = 'SilentlyContinue'
        $desktop_folder = DesktopFolder
        if (Test-Path -LiteralPath $cache_folder) {
            remove-item $cache_folder -Recurse -Force
            remove-item $desktop_folder\Spotify.lnk -Recurse -Force
        }
    }
}

if ($exp_standart) { Write-Host ($lang).ExpStandart`n }
if ($exp_spotify) { Write-Host ($lang).ExpSpotify`n }

function Helper($paramname) {

    switch ( $paramname ) {
        "HtmlLicMin" { 
            # licenses.html minification
            $html_lic_min = @{
                HtmlLicMin1 = '<li><a href="#6eef7">zlib<\/a><\/li>\n(.|\n)*<\/p><!-- END CONTAINER DEPS LICENSES -->(<\/div>)', '$2'
                HtmlLicMin2 = '	', ''
                HtmlLicMin3 = '  ', ''
                HtmlLicMin4 = '(?m)(^\s*\r?\n)', ''
                HtmlLicMin5 = '\r?\n(?!\(1|\d)', ''
            }
            $n = ($lang).NoVariable3
            $contents = $html_lic_min
            $paramdata = $xpuiContents_html
        }
        "OffadsonFullscreen" { 
            $offadson_fullscreen = @{
                EmptyBlockAd        = 'adsEnabled:!0', 'adsEnabled:!1' # Removing an empty block
                FullScreenAd        = '(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===', '$1"premium"===$2$3"free"===' # Fullscreen act., removing upgrade menu, button
                PlaylistSponsorsOff = 'allSponsorships' , '' # Disabling a playlist sponsor
                ConnectUnlock       = ' connect-device-list-item--disabled' , '' # Connect unlock test for 1.1.91
                ConnectUnlock2      = 'connect-picker.unavailable-to-control' , 'spotify-connect'
                ConnectUnlock3      = '(className:.,disabled:)(..)' , '$1false'
                ConnectUnlock4      = 'return (..isDisabled)(\?..createElement\(..,)' , 'return false$2'
            }
            #if (!($testconnect)) {
            #    $offadson_fullscreen.Remove('ConnectUnlock'), $offadson_fullscreen.Remove('ConnectUnlock2'),
            #    $offadson_fullscreen.Remove('ConnectUnlock3'), $offadson_fullscreen.Remove('ConnectUnlock4')
            #}
            $n = ($lang).NoVariable2
            $contents = $offadson_fullscreen
            $paramdata = $xpui_js
        }
        "OffPodcasts" {  
            # Turn off podcasts
            $podcasts_off = @{
                PodcastsOff1 = 'withQueryParameters\(e\){return this.queryParameters=e,this}', 'withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}'
                PodcastsOff2 = ',this[.]enableShows=[a-z]', ''
            }
            $n = ($lang).NoVariable2
            $contents = $podcasts_off
            $paramdata = $xpui_js
        }
        "OffRujs" { 
            # Remove all languages except En and Ru from xpui.js
            $rus_js = @{
                OffRujs = '(en:{displayName:"English",displayNameEn:"English"}).*"Zulu"', '$1,ru:{displayName:"Русский",displayNameEn:"Russian"'
            }
            $n = ($lang).NoVariable2
            $contents = $rus_js
            $paramdata = $xpui_js

        }
        "RuTranslate" { 
            # Additional translation of some words for the Russian language
            $ru_translate = @{
                EnhancePlaylist    = '"To Enhance this playlist, you.ll need to go online."', '"Чтобы улучшить этот плейлист, вам нужно подключиться к интернету."'
                ConfirmAge         = '"Confirm your age"', '"Подтвердите свой возраст"' 
                Premium            = '"%price%\/month after. Terms and conditions apply. One month free not available for users who have already tried Premium."', '"%price%/месяц спустя. Принять условия. Один месяц бесплатно, недоступно для пользователей, которые уже попробовали Premium."'
                AdFreeMusic        = '"Enjoy ad-free music listening, offline listening, and more. Cancel anytime."', '"Наслаждайтесь прослушиванием музыки без рекламы, прослушиванием в офлайн режиме и многим другим. Отменить можно в любое время."'
                AddPlaylist        = '"Add to another playlist"', '"Добавить в другой плейлист"' 
                OfflineStorage     = '"Offline storage location"', '"Хранилище скачанных треков"' 
                ChangeLocation     = '"Change location"', '"Изменить место"' 
                Linebreaks         = '"Line breaks aren.t supported in the description."', '"В описании не поддерживаются разрывы строк."' 
                PressSave          = '"Press save to keep changes you.ve made."', '"Нажмите «Сохранить», чтобы сохранить внесенные изменения."' 
                NoInternet         = '"No internet connection found. Changes to description and image will not be saved."', '"Подключение к интернету не найдено. Изменения в описании и изображении не будут сохранены."' 
                ImageSmall         = '"Image too small. Images must be at least [{]0[}]x[{]1[}]."', '"Изображение слишком маленькое. Изображения должны быть не менее {0}x{1}."' 
                FailedUpload       = '"Failed to upload image. Please try again."', '"Не удалось загрузить изображение. Пожалуйста, попробуйте снова."' 
                Description        = '"Description"', '"Описание"' 
                ChangePhoto        = '"Change photo"', '"Сменить изображение"' 
                RemovePhoto        = '"Remove photo"', '"Удалить изображение"' 
                Name               = '"Name"', '"Имя"' 
                ChangeSpeed        = '"Change speed"', '"Изменение скорости"' 
                Years19            = '"You need to be at least 19 years old to listen to explicit content marked with"', '"Вам должно быть не менее 19 лет, чтобы слушать непристойный контент, помеченный значком"' 
                AddPlaylist2       = '"Add to this playlist"', '"Добавить в этот плейлист"'
                NoConnect          = '"Couldn.t connect to Spotify."', '"Не удалось подключиться к Spotify."' 
                Reconnecting       = '"Reconnecting..."', '"Повторное подключение..."' 
                NoConnection       = '"No connection"', '"Нет соединения"' 
                CharacterCounter   = '"Character counter"', '"Счетчик символов"' 
                Lightsaber         = '"Toggle lightsaber hilt. Current is [{]0[}]."', '"Переключить рукоять светового меча. Текущий {0}."' 
                SongAvailable      = '"Song not available"', '"Песня недоступна"' 
                HiFi               = '"The song you.re trying to listen to is not available in HiFi at this time."', '"Песня, которую вы пытаетесь прослушать, в настоящее время недоступна в HiFi."' 
                Quality            = '"Current audio quality:"', '"Текущее качество звука:"' 
                Network            = '"Network connection"', '"Подключение к сети"' 
                Good               = '"Good"', '"Хорошее"' 
                Poor               = '"Poor"', '"Плохое"' 
                Yes                = '"Yes"', '"Да"' 
                No                 = '"No"', '"Нет"' 
                Location           = '"Your Location"', '"Ваше местоположение"'
                NetworkConnection  = '"Network connection failed while playing this content."', '"Сбой сетевого подключения при воспроизведении этого контента."'
                ContentLocation    = '"We.re not able to play this content in your current location."', '"Мы не можем воспроизвести этот контент в вашем текущем местоположении."'
                ContentUnavailable = '"This content is unavailable. Try another\?"', '"Этот контент недоступен. Попробуете другой?"'
                NoContent          = '"Sorry, we.re not able to play this content."', '"К сожалению, мы не можем воспроизвести этот контент."'
                NoContent2         = '"Hmm... we can.t seem to play this content. Try installing the latest version of Spotify."', '"Хм... похоже, мы не можем воспроизвести этот контент. Попробуйте установить последнюю версию Spotify."'
                NoContent3         = '"Please upgrade Spotify to play this content."', '"Пожалуйста, обновите Spotify, чтобы воспроизвести этот контент."'
                NoContent4         = '"This content cannot be played on your operating system version."', '"Этот контент нельзя воспроизвести в вашей версии операционной системы."'
                DevLang            = '"Override certain user attributes to test regionalized content programming. The overrides are only active in this app."', '"Переопределите определенные атрибуты пользователя, чтобы протестировать региональное программирование контента. Переопределения активны только в этом приложении."'
                AlbumRelease       = '"...name... was released this week!"', '"\"%name%\" был выпущен на этой неделе!"'
                AlbumReleaseOne    = '"one": "\\"%name%\\" was released %years% year ago this week!"', '"one": "\"%name%\" был выпущен %years% год назад на этой неделе!"'
                AlbumReleaseFew    = '"few": "\\"%name%\\" was released %years% years ago this week!"', '"few": "\"%name%\" был выпущен %years% года назад на этой неделе!"'
                AlbumReleaseMany   = '"many": "\\"%name%\\" was released %years% years ago this week!"', '"many": "\"%name%\" был выпущен %years% лет назад на этой неделе!"'
                AlbumReleaseOther  = '"other": "\\"%name%\\" was released %years% years ago this week!"', '"other": "\"%name%\" был выпущен %years% года назад на этой неделе!"'
                Speed              = '"Speed [{]0[}]×"', '"Скорость {0}×"'
                AudiobookFree      = '"This audiobook is free"', '"Эта аудиокнига бесплатна"'
                AudiobookGet       = '"Get"', '"Получить"'
                AudiobookBy        = '"Buy"', '"Купить"'
            }
            $n = ($lang).NoVariable5
            $contents = $ru_translate
            $paramdata = $xpui_ru
        }

        "ExpFeature" { 
            # Experimental Feature Standart
            $exp_features = @{
                ExpFeatures1  = '(Enable Liked Songs section on Artist page",default:)(!1)', '$1!0' 
                ExpFeatures2  = '(Enable block users feature in clientX",default:)(!1)', '$1!0' 
                ExpFeatures3  = '(Enables quicksilver in-app messaging modal",default:)(!0)', '$1!1' 
                ExpFeatures4  = '(With this enabled, clients will check whether tracks have lyrics available",default:)(!1)', '$1!0' 
                ExpFeatures5  = '(Enables new playlist creation flow in Web Player and DesktopX",default:)(!1)', '$1!0'
                ExpFeatures6  = '(Adds a search box so users are able to filter playlists when trying to add songs to a playlist using the contextmenu",default:)(!1)', '$1!0'
                ExpFeatures7  = '(Enable Ignore In Recommendations for desktop and web",default:)(!1)', '$1!0'
                ExpFeatures8  = '(Enable Playlist Permissions flows for Prod",default:)(!1)', '$1!0'
                ExpFeatures9  = '(Enable showing balloons on album release date anniversaries",default:)(!1)', '$1!0'
                ExpFeatures10 = '(Enable Enhance Liked Songs UI and functionality",default:)(!1)', '$1!0'
                ExpFeatures11 = '(Enable Enhance Playlist UI and functionality for end-users",default:)(!1)', '$1!0' 
                ExpFeatures12 = '(Enable a condensed disography shelf on artist pages",default:)(!1)', '$1!0' 
                ExpFeatures13 = '(Enable Lyrics match labels in search results",default:)(!1)', '$1!0'  
                ExpFeatures14 = '(Enable audio equalizer for Desktop and Web Player",default:)(!1)', '$1!0' 
                ExpFeatures15 = '(Enable showing a new and improved device picker UI",default:)(!1)', '$1!0'
                ExpFeatures16 = '(Enable the new home structure and navigation",default:)(!1)', '$1!0'
                ExpFeatures17 = '(Show "Made For You" entry point in the left sidebar.,default:)(!1)', '$1!0'
            }
            if ($enhance_like_off) { $exp_features.Remove('ExpFeatures10') }
            if ($enhance_playlist_off) { $exp_features.Remove('ExpFeatures11') }
            if ($new_artist_pages_off) { $exp_features.Remove('ExpFeatures12') }
            if ($new_lyrics_off) { $exp_features.Remove('ExpFeatures13') }
            if ($equalizer_off) { $exp_features.Remove('ExpFeatures14') }
            if ($device_new_off) { $exp_features.Remove('ExpFeatures15') }
            if (!($enablenavalt)) { $exp_features.Remove('ExpFeatures16') }
            if ($made_for_you_off) { $exp_features.Remove('ExpFeatures17') }
            if ($exp_standart) {
                $exp_features.Remove('ExpFeatures10'), $exp_features.Remove('ExpFeatures11'), 
                $exp_features.Remove('ExpFeatures12'), $exp_features.Remove('ExpFeatures13'), 
                $exp_features.Remove('ExpFeatures14'), $exp_features.Remove('ExpFeatures15'), 
                $exp_features.Remove('ExpFeatures16'), $exp_features.Remove('ExpFeatures17')
            }
            $n = ($lang).NoVariable2
            $contents = $exp_features
            $paramdata = $xpui_js
        }
    }

    $contents.Keys | Sort-Object | ForEach-Object { 
 
        if ($paramdata -match $contents.$PSItem[0]) { 
            $paramdata = $paramdata -replace $contents.$PSItem[0], $contents.$PSItem[1] 
        }
        else { 
            Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline 
            Write-Host "`$contents.$PSItem"$n
        }    
    }
    $paramdata
}

Write-Host ($lang).ModSpoti`n

# Patching files
if (!($premium)) {
    $patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
    Copy-Item -LiteralPath $patchFiles -Destination "$spotifyDirectory"
}
$tempDirectory = $PWD
Pop-Location

Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"
$xpui_css_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css"
$xpui_lic_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html"
if ($ru) { $xpui_ru_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json" }
$test_spa = Test-Path -Path $xpui_spa_patch
$test_js = Test-Path -Path $xpui_js_patch
$xpui_js_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js.bak"
$xpui_css_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css.bak"
$xpui_lic_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html.bak"
if ($ru) { $xpui_ru_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json.bak" }
$spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"


if ($test_spa -and $test_js) {
    Write-Host ($lang).Error -ForegroundColor Red
    Write-Host ($lang).FileLocBroken
    Write-Host ($lang).StopScrpit
    pause
    Exit
}

if (Test-Path $xpui_js_patch) {
    Write-Host ($lang).Spicetify`n

    # Delete all files except "en", "ru" and "__longest"
    if ($ru) {
        $patch_lang = "$env:APPDATA\Spotify\Apps\xpui\i18n"
        Remove-Item $patch_lang -Exclude *en*, *ru*, *__longest* -Recurse
    }

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_test_js = $reader.ReadToEnd()
    $reader.Close()
        
    If ($xpui_test_js -match 'patched by spotx') {

        $test_xpui_js_bak = Test-Path -Path $xpui_js_bak_patch
        $test_xpui_css_bak = Test-Path -Path $xpui_css_bak_patch
        $test_xpui_lic_bak = Test-Path -Path $xpui_lic_bak_patch
        if ($ru) { $test_xpui_ru_bak = Test-Path -Path $xpui_ru_bak_patch }
        $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch

        if ($test_xpui_js_bak -and $test_xpui_css_bak) {
            
            Remove-Item $xpui_js_patch -Recurse -Force
            Rename-Item $xpui_js_bak_patch $xpui_js_patch
            
            Remove-Item $xpui_css_patch -Recurse -Force
            Rename-Item $xpui_css_bak_patch $xpui_css_patch
            
            if ($test_xpui_lic_bak) {
                Remove-Item $xpui_lic_patch -Recurse -Force
                Rename-Item $xpui_lic_bak_patch $xpui_lic_patch
            }
            if ($test_xpui_ru_bak -and $ru) {
                Remove-Item $xpui_ru_patch -Recurse -Force
                Rename-Item $xpui_ru_bak_patch $xpui_ru_patch
            }
            if ($test_spotify_exe_bak) {
                Remove-Item $spotifyExecutable -Recurse -Force
                Rename-Item $spotify_exe_bak_patch $spotifyExecutable
            }

        }
        else {
            Write-Host ($lang).NoRestore`n
            Pause
            Exit
        }

    }

    Copy-Item $xpui_js_patch $xpui_js_bak_patch
    Copy-Item $xpui_css_patch $xpui_css_bak_patch
    Copy-Item $xpui_lic_patch $xpui_lic_bak_patch
    if ($ru) { Copy-Item $xpui_ru_patch $xpui_ru_bak_patch }

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Turn off podcasts
    if ($Podcast_off) { $xpui_js = Helper -paramname "OffPodcasts" }
    
    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) { $xpui_js = Helper -paramname "OffadsonFullscreen" } 

    # Experimental Feature
    if (!($exp_spotify)) { $xpui_js = Helper -paramname "ExpFeature" }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { $xpui_js = Helper -paramname "OffRujs" }

    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()  

    # Russian additional translation
    if ($ru) {
        $file_ru = get-item $env:APPDATA\Spotify\Apps\xpui\i18n\ru.json
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_ru
        $xpui_ru = $reader.ReadToEnd()
        $reader.Close()
        $xpui_ru = Helper -paramname "RuTranslate"
        $writer = New-Object System.IO.StreamWriter -ArgumentList $file_ru
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpui_ru)
        $writer.Close()  
    }

    # xpui.css
    $file_xpui_css = get-item $env:APPDATA\Spotify\Apps\xpui\xpui.css
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_xpui_css
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()

    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_xpui_css
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    if (!($premium)) {
        # Hide download icon on different pages
        $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH{display:none}')
        # Hide submenu item "download"
        $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA{display:none}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    # Hide broken podcast menu
    if ($podcast_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"]{display:none}')
    }
    $writer.Close()

    # licenses.html minification
    $file_licenses = get-item $env:APPDATA\Spotify\Apps\xpui\licenses.html
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_licenses
    $xpuiContents_html = $reader.ReadToEnd()
    $reader.Close()
    $xpuiContents_html = Helper -paramname "HtmlLicMin" 
    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_licenses
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html)
    $writer.Close()
}  

If (Test-Path $xpui_spa_patch) {

    $bak_spa = "$env:APPDATA\Spotify\Apps\xpui.bak"
    $test_bak_spa = Test-Path -Path $bak_spa

    # Make a backup copy of xpui.spa if it is original
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry.Open())
    $patched_by_spotx = $reader.ReadToEnd()
    $reader.Close()

    If ($patched_by_spotx -match 'patched by spotx') {
        $zip.Dispose()    

        if ($test_bak_spa) {
            Remove-Item $xpui_spa_patch -Recurse -Force
            Rename-Item $bak_spa $xpui_spa_patch

            $spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"
            $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch
            if ($test_spotify_exe_bak) {
                Remove-Item $spotifyExecutable -Recurse -Force
                Rename-Item $spotify_exe_bak_patch $spotifyExecutable
            }
        }
        else {
            Write-Host ($lang).NoRestore2`n
            Pause
            Exit
        }
        $spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"
        $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch
        if ($test_spotify_exe_bak) {
            Remove-Item $spotifyExecutable -Recurse -Force
            Rename-Item $spotify_exe_bak_patch $spotifyExecutable
        }
    }
    $zip.Dispose()
    Copy-Item $xpui_spa_patch $env:APPDATA\Spotify\Apps\xpui.bak

    # Remove all languages except En and Ru from xpui.spa
    if ($ru) {
        [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression') | Out-Null

        $files = 'af.json', 'am.json', 'ar.json', 'az.json', 'bg.json', 'bho.json', 'bn.json', `
            'cs.json', 'da.json', 'de.json', 'el.json', 'es-419.json', 'es.json', 'et.json', 'fa.json', `
            'fi.json', 'fil.json', 'fr-CA.json', 'fr.json', 'gu.json', 'he.json', 'hi.json', 'hu.json', `
            'id.json', 'is.json', 'it.json', 'ja.json', 'kn.json', 'ko.json', 'lt.json', 'lv.json', `
            'ml.json', 'mr.json', 'ms.json', 'nb.json', 'ne.json', 'nl.json', 'or.json', 'pa-IN.json', `
            'pl.json', 'pt-BR.json', 'pt-PT.json', 'ro.json', 'sk.json', 'sl.json', 'sr.json', 'sv.json', `
            'sw.json' , 'ta.json' , 'te.json' , 'th.json' , 'tr.json' , 'uk.json' , 'ur.json' , 'vi.json', `
            'zh-CN.json', 'zh-TW.json' , 'zu.json' , 'pa-PK.json' , 'hr.json'

        $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
        $mode = [IO.Compression.ZipArchiveMode]::Update
        $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

    ($zip_xpui.Entries | Where-Object { $files -contains $_.Name }) | ForEach-Object { $_.Delete() }

        $zip_xpui.Dispose()
        $stream.Close()
        $stream.Dispose()
    }

    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
    # xpui.js
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Turn off podcasts
    if ($podcast_off) { $xpui_js = Helper -paramname "OffPodcasts" }
    
    if (!($premium)) {
        # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
        $xpui_js = Helper -paramname "OffadsonFullscreen"
    }

    # Experimental Feature
    if (!($exp_spotify)) { $xpui_js = Helper -paramname "ExpFeature" }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { $xpui_js = Helper -paramname "OffRujs" }

    # Disabled logging
    $xpui_js = $xpui_js -replace "sp://logging/v3/\w+", ""
   
    $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()

    # Disable Sentry (vendor~xpui.js)
    $entry_vendor_xpui = $zip.GetEntry('vendor~xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_vendor_xpui.Open())
    $xpuiContents_vendor = $reader.ReadToEnd()
    $reader.Close()

    $xpuiContents_vendor = $xpuiContents_vendor `
        -replace "prototype\.bindClient=function\(\w+\)\{", '${0}return;'
    $writer = New-Object System.IO.StreamWriter($entry_vendor_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_vendor)
    $writer.Close()

    # minification of all *.js
    $zip.Entries | Where-Object FullName -like '*.js' | ForEach-Object {
        $readerjs = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_js = $readerjs.ReadToEnd()
        $readerjs.Close()

        $xpuiContents_js = $xpuiContents_js `
            -replace "[/][/][#] sourceMappingURL=.*[.]map", "" -replace "\r?\n(?!\(1|\d)", ""

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_js)
        $writer.Close()
    }

    # xpui.css
    $entry_xpui_css = $zip.GetEntry('xpui.css')
    $reader = New-Object System.IO.StreamReader($entry_xpui_css.Open())
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()
        
    $writer = New-Object System.IO.StreamWriter($entry_xpui_css.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    if (!($premium)) {
        # Hide download icon on different pages
        $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH {display: none}')
        # Hide submenu item "download"
        $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display: none}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    # Hide broken podcast menu
    if ($podcast_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"] {display: none}')
    }
    $writer.Close()

    # of all *.Css
    $zip.Entries | Where-Object FullName -like '*.css' | ForEach-Object {
        $readercss = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_css = $readercss.ReadToEnd()
        $readercss.Close()

        $xpuiContents_css = $xpuiContents_css `
            <# Remove RTL #>`
            -replace "}\[dir=ltr\]\s?([.a-zA-Z\d[_]+?,\[dir=ltr\])", '}[dir=str] $1' -replace "}\[dir=ltr\]\s?", "} " -replace "html\[dir=ltr\]", "html" `
            -replace ",\s?\[dir=rtl\].+?(\{.+?\})", '$1' -replace "[\w\-\.]+\[dir=rtl\].+?\{.+?\}", "" -replace "\}\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\}\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\[lang=ar\].+?\{.+?\}", "" -replace "html\[dir=rtl\].+?\{.+?\}", "" -replace "html\[lang=ar\].+?\{.+?\}", "" `
            -replace "\[dir=rtl\].+?\{.+?\}", "" -replace "\[dir=str\]", "[dir=ltr]" `
            <# Css minification #>`
            -replace "[/]\*([^*]|[\r\n]|(\*([^/]|[\r\n])))*\*[/]", "" -replace "[/][/]#\s.*", "" -replace "\r?\n(?!\(1|\d)", ""
    
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_css)
        $writer.Close()
    }
    
    # licenses.html minification
    $zip.Entries | Where-Object FullName -like '*licenses.html' | ForEach-Object {
        $reader = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_html = $reader.ReadToEnd()
        $reader.Close()      
        $xpuiContents_html = Helper -paramname "HtmlLicMin"
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_html)
        $writer.Close()
    }

    # blank.html minification
    $entry_blank_html = $zip.GetEntry('blank.html')
    $reader = New-Object System.IO.StreamReader($entry_blank_html.Open())
    $xpuiContents_html_blank = $reader.ReadToEnd()
    $reader.Close()

    $html_min1 = "  "
    $html_min2 = "(?m)(^\s*\r?\n)"
    $html_min3 = "\r?\n(?!\(1|\d)"
    if ($xpuiContents_html_blank -match $html_min1) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min1, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min1 "($lang).NoVariable4 }
    if ($xpuiContents_html_blank -match $html_min2) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min2, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min2 "($lang).NoVariable4 }
    if ($xpuiContents_html_blank -match $html_min3) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min3, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min3 "($lang).NoVariable4 }

    $xpuiContents_html_blank = $xpuiContents_html_blank
    $writer = New-Object System.IO.StreamWriter($entry_blank_html.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html_blank)
    $writer.Close()
    
    if ($ru) {
        # Additional translation of the ru.json file
        $zip.Entries | Where-Object FullName -like '*ru.json' | ForEach-Object {
            $readerjson = New-Object System.IO.StreamReader($_.Open())
            $xpui_ru = $readerjson.ReadToEnd()
            $readerjson.Close()

    
            $xpui_ru = Helper -paramname "RuTranslate"
            $writer = New-Object System.IO.StreamWriter($_.Open())
            $writer.BaseStream.SetLength(0)
            $writer.Write($xpui_ru)
            $writer.Close()
        }
    }
    # Json
    $zip.Entries | Where-Object FullName -like '*.json' | ForEach-Object {
        $readerjson = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_json = $readerjson.ReadToEnd()
        $readerjson.Close()

        # json minification
        $xpuiContents_json = $xpuiContents_json `
            -replace "  ", "" -replace "    ", "" -replace '": ', '":' -replace "\r?\n(?!\(1|\d)", "" 

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_json)
        $writer.Close()       
    }
    $zip.Dispose()   
}

# Delete all files except "en" and "ru"
if ($ru) {
    $patch_lang = "$spotifyDirectory\locales"
    Remove-Item $patch_lang -Exclude *en*, *ru* -Recurse
}

# Shortcut Spotify.lnk
$ErrorActionPreference = 'SilentlyContinue' 

$desktop_folder = DesktopFolder

If (!(Test-Path $desktop_folder\Spotify.lnk)) {
    $source = "$env:APPDATA\Spotify\Spotify.exe"
    $target = "$desktop_folder\Spotify.lnk"
    $WorkingDir = "$env:APPDATA\Spotify"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.WorkingDirectory = $WorkingDir
    $Shortcut.TargetPath = $source
    $Shortcut.Save()      
}

# Block updates
$ErrorActionPreference = 'SilentlyContinue'
$update_test_exe = Test-Path -Path $spotifyExecutable

if ($block_update) {

    if ($update_test_exe) {
        $exe = "$env:APPDATA\Spotify\Spotify.exe"
        $ANSI = [Text.Encoding]::GetEncoding(1251)
        $old = [IO.File]::ReadAllText($exe, $ANSI)

        if ($old -match "(?<=wg:\/\/desktop-update\/.)7(\/update)") {
            Write-Host ($lang).UpdateBlocked`n
        }
        elseif ($old -match "(?<=wg:\/\/desktop-update\/.)2(\/update)") {
            if (Test-Path -LiteralPath $exe_bak) { 
                Remove-Item $exe_bak -Recurse -Force
                Start-Sleep -Milliseconds 150
            }
            copy-Item $exe $exe_bak
            $new = $old -replace "(?<=wg:\/\/desktop-update\/.)2(\/update)", '7/update'
            [IO.File]::WriteAllText($exe, $new, $ANSI)
        }
        else {
            Write-Host ($lang).UpdateError`n -ForegroundColor Red
        }
    }
    else {
        Write-Host ($lang).NoSpotifyExe`n -ForegroundColor Red 
    }
}

# Automatic cache clearing
if ($cache_install) {
    Start-Sleep -Milliseconds 200
    New-Item -Path $env:APPDATA\Spotify\ -Name "cache" -ItemType "directory" | Out-Null

    # Download cache script
    downloadScripts -param1 "cache-spotify"
    downloadScripts -param1 "hide_window"
    downloadScripts -param1 "run_ps"

    # Spotify.lnk
    $source2 = "$cache_folder\hide_window.vbs"
    $target2 = "$desktop_folder\Spotify.lnk"
    $WorkingDir2 = "$cache_folder"
    $WshShell2 = New-Object -comObject WScript.Shell
    $Shortcut2 = $WshShell2.CreateShortcut($target2)
    $Shortcut2.WorkingDirectory = $WorkingDir2
    $Shortcut2.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
    $Shortcut2.TargetPath = $source2
    $Shortcut2.Save()

    if ($number_days -match "^[1-9][0-9]?$|^100$") {
        $file_cache_spotify_ps1 = Get-Content $cache_folder\cache_spotify.ps1 -Raw
        $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace '7', $number_days
        Set-Content -Path $cache_folder\cache_spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
        $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$cache_folder\cache_spotify.ps1")
        $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
        [System.IO.File]::WriteAllText("$cache_folder\cache_spotify.ps1", $contentcache_spotify_ps1)

        $infile = "$cache_folder\cache_spotify.ps1"
        $outfile = "$cache_folder\cache_spotify2.ps1"

        $sr = New-Object System.IO.StreamReader($infile) 
        $sw = New-Object System.IO.StreamWriter($outfile, $false, [System.Text.Encoding]::Default)
        $sw.Write($sr.ReadToEnd())
        $sw.Close()
        $sr.Close() 
        $sw.Dispose()
        $sr.Dispose()

        Start-Sleep -Milliseconds 200
        Remove-item $infile -Recurse -Force
        Rename-Item -path $outfile -NewName $infile
    }
}

if ($start_spoti) { Start-Process -WorkingDirectory $spotifyDirectory -FilePath $spotifyExecutable }

Write-Host ($lang).InstallComplete`n -ForegroundColor Green
