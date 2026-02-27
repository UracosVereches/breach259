AddCSLuaFile()

AWarn.localizations = {}
AWarn.localizations.localLang = "EN" --Set this to your language from the list below, or add your own (See below for instructions)

--[[
Available Languages:
	EN		-	English
	FIN		-	Finnish		- provided by [SPR] Hodas (http://steamcommunity.com/id/Hodas/)
	TR		-	Turkish	 	- provided by saviorsoldier (http://steamcommunity.com/profiles/76561198057034162)
	DE		-	German	 	- provided by Martin (http://steamcommunity.com/id/martin_link/)
	RU		-	Russian	 	- provided by Snappi (http://steamcommunity.com/id/snappi_incognito/)
	FR		-	French   	- provided by Driven (http://steamcommunity.com/profiles/76561197986344922)
	PT		-	Portuguese	- provided by Comedian (http://steamcommunity.com/id/comedinha/)
]]

--[[
Localization Tables
 ++ To create a new language, copy the entire 'EN' table below and paste it as its own table.
 ++ Change 'EN' to whatever code you wish to use for your language.
 ++ Go through and edit the strings in your language table.
 ++ Change AWarn.localizations.localLang = "EN" to whatever language string you choose.
 
 -- If you create a table for your language, send it to me and I'll add it officially and give you credit!
]]

AWarn.localizations["EN"] = {
	cl1		=		"AWarn Menu", --Found in cl_init.lua
	cl2		=		"Version", --Found in cl_init.lua
	cl3		=		"Right Click on a player for more options!", --Found in cl_init.lua
	cl4		=		"Selected Player's Active Warnings", --Found in cl_init.lua
	cl5		=		"Selected Player's Total Warnings", --Found in cl_init.lua
	cl6		=		"Options", --Found in cl_init.lua
	cl7		=		"Warning Admin", --Found in cl_init.lua
	cl8		=		"Reason", --Found in cl_init.lua
	cl9		=		"Server", --Found in cl_init.lua
	cl10	=		"Date/Time", --Found in cl_init.lua
	cl11	=		"Delete Warning", --Found in cl_init.lua
	cl12	=		"Copy To Clipboard", --Found in cl_init.lua
	cl13	=		"Warning reason copied to clipboard!", --Found in cl_init.lua
	cl14	=		"Player Name", --Found in cl_init.lua
	cl15	=		"Warn", --Found in cl_init.lua
	cl16	=		"Clear Warnings", --Found in cl_init.lua
	cl17	=		"Reduce Active Warnings", --Found in cl_init.lua
	cl18	=		"Showing your warnings!", --Found in cl_init.lua
	cl19	=		"Your Active Warnings: ", --Found in cl_init.lua
	cl20	=		"Your  Total  Warnings: ", --Found in cl_init.lua
	cl21	=		"AWarn Warning Menu", --Found in cl_init.lua
	cl22	=		"Warning Player: ", --Found in cl_init.lua
	cl23	=		"SUBMIT", --Found in cl_init.lua
	cl24	=		"CANCEL", --Found in cl_init.lua
	cl25	=		"AWarn Options Menu", --Found in cl_init.lua
	cl26	=		"Allow AWarn to KICK players (defined in the punishment settings file)", --Found in cl_init.lua
	cl27	=		"Allow AWarn to BAN players (defined in the punishment settings file)", --Found in cl_init.lua
	cl28	=		"Player's active warnings will decay over time.", --Found in cl_init.lua
	cl29	=		"Admins are required to submit a reason when they warn someone.", --Found in cl_init.lua
	cl30	=		"Player's active warnings will be reset after a ban through AWarn.", --Found in cl_init.lua
	cl31	=		"Log AWarn Actions to a data file.", --Found in cl_init.lua
	cl32	=		"Decay Rate (in minutes)", --Found in cl_init.lua
	cl33	=		"Additional Punishment settings/configurations can be found in:", --Found in cl_init.lua
	cl34	=		"was warned by", --Found in cl_init.lua
	cl35	=		"warned", --Found in cl_init.lua/sv_init.lua
	cl36	=		"Make sure you wrap the steamID in quotes!", --Found in cl_init.lua/sv_init.lua
	cl37	=		"Player Not Found!", --Found in cl_init.lua/sv_init.lua
	
	sv1		=		"You do not have access to this command.", --Found in sv_init.lua
	sv2		=		"You can not set this CVar with this command.", --Found in sv_init.lua
	sv3		=		"You must pass this ConVar a positive value.", --Found in sv_init.lua
	sv4		=		"You are not allowed to warn other admins.", --Found in sv_init.lua
	sv5		=		"You MUST include a reason. Disable this in the options.", --Found in sv_init.lua
	sv6		=		"You have been warned by", --Found in sv_init.lua
	sv7		=		"Type !warn to see a list of your warnings.", --Found in sv_init.lua/awarn_sql.lua
	sv8		=		"This command can not be run from the server's console!", --Found in sv_init.lua
	sv9		=		"This player can not be warned!", --Found in sv_awarn.lua
	sv10	=		"Players in this group can not be warned!", --Found in sv_awarn.lua
	
	sql1	=		"was kicked for reaching the warning threshold", --Found in awarn_sql.lua
	sql2	=		"was banned for reaching the warning threshold", --Found in awarn_sql.lua
	sql3	=		"This player has no warnings on record", --Found in awarn_sql.lua
	sql4	=		"Warnings reduced by 1 for player: ", --Found in awarn_sql.lua
	sql5	=		"This player has 0 active warnings already", --Found in awarn_sql.lua
	sql6	=		"Cleared all warnings for player", --Found in awarn_sql.lua
	sql7	=		"Record for this warning ID not found", --Found in awarn_sql.lua
	sql8	=		"Welcome back to the server", --Found in awarn_sql.lua
	sql9	=		"Current Active Warnings", --Found in awarn_sql.lua
	sql10	=		"joins the server", --Found in awarn_sql.lua
	sql11	=		"Total Warnings", --Found in awarn_sql.lua
}

--[[
	Finnish translation provided by [SPR] Hodas (http://steamcommunity.com/id/Hodas/)
]]
AWarn.localizations["FIN"] = {
    cl1     =       "AWarn Menu", --Found in cl_init.lua
    cl2     =       "Versio", --Found in cl_init.lua
    cl3     =       "Paina oikealla hiiren näppäimellä pelaajaa saadaksesi lisää vaihtoehtoja!", --Found in cl_init.lua
    cl4     =       "Valitun pelaajan aktiiviset varoitukset", --Found in cl_init.lua
    cl5     =       "Valitun pelaajan varoitukset kokonaisuudessaan", --Found in cl_init.lua
    cl6     =       "Asetukset", --Found in cl_init.lua
    cl7     =       "Varoituksen antanut Valvoja", --Found in cl_init.lua
    cl8     =       "Syy", --Found in cl_init.lua
    cl9     =       "Palvelin", --Found in cl_init.lua
    cl10    =       "Päiväys/Aika", --Found in cl_init.lua
    cl11    =       "Poista Varoitus", --Found in cl_init.lua
    cl12    =       "Kopio", --Found in cl_init.lua
    cl13    =       "Varoituksen syy kopioitu!", --Found in cl_init.lua
    cl14    =       "Pelaajan nimi", --Found in cl_init.lua
    cl15    =       "Varoita", --Found in cl_init.lua
    cl16    =       "Tyhjennä varoitukset", --Found in cl_init.lua
    cl17    =       "Vähennä aktiivisia varoituksia", --Found in cl_init.lua
    cl18    =       "Näyttää varoituksesi!", --Found in cl_init.lua
    cl19    =       "Sinun aktiiviset varoitukset: ", --Found in cl_init.lua
    cl20    =       "Sinun varoitukset kokonaisuudessaan: ", --Found in cl_init.lua
    cl21    =       "AWarn Varoitus valikko", --Found in cl_init.lua
    cl22    =       "Varoita pelaaja: ", --Found in cl_init.lua
    cl23    =       "Lähetä", --Found in cl_init.lua
    cl24    =       "Peruuta", --Found in cl_init.lua
    cl25    =       "AWarn asetukset valikko", --Found in cl_init.lua
    cl26    =       "Salli AWarnin poistaa pelaaja (asetettu rankaisemisen asetuksissa)", --Found in cl_init.lua
    cl27    =       "Salli AWarnin bannata pelaaja (asetettu rankaisemisen asetuksissa)", --Found in cl_init.lua
    cl28    =       "Pelaajien aktiiviset varoitukset vähenevät ajan kuluessa.", --Found in cl_init.lua
    cl29    =       "Valvojat tarvitsevat syyn varoittaakseen.", --Found in cl_init.lua
    cl30    =       "Pelaajien aktiiviset varoitukset ovat poistettu bannien jälkeen AWarnin kautta.", --Found in cl_init.lua
    cl31    =       "tallenna Awarnin tapahtumat data tiedostoon.", --Found in cl_init.lua
    cl32    =       "Ajan kuluman nopeus (Minuuteissa)", --Found in cl_init.lua
    cl33    =       "Vaihtoehtoisten rankaisemisen asetukset löytää:", --Found in cl_init.lua
    cl34    =       "Varoittanut valvoja", --Found in cl_init.lua
    cl35    =       "varoitettu", --Found in cl_init.lua/sv_init.lua
    cl36    =       "Muista laittaa SteamID heittomerkkien sisään!", --Found in cl_init.lua/sv_init.lua
    cl37    =       "Pelaajaa ei löydy!", --Found in cl_init.lua/sv_init.lua
   
    sv1     =       "Sinulla ei ole lupaa tähän komentoon.", --Found in sv_init.lua
    sv2     =       "Et voi laittaa tätä console komentoa tällä komennolla.", --Found in sv_init.lua
    sv3     =       "Sinun täytyy laittaa tämä consoli komento positiivisella numerolla.", --Found in sv_init.lua
    sv4     =       "Et voi varoittaa toisia valvojia.", --Found in sv_init.lua
    sv5     =       "Sinun täytyy lisätä syy. Poista tämä käytöstä asetuksista.", --Found in sv_init.lua
    sv6     =       "Sinua on varoittanut", --Found in sv_init.lua
    sv7     =       "Kirjoita !warn nähdäksesi kaikki varoituksesi.", --Found in sv_init.lua/awarn_sql.lua
    sv8     =       "Tätä komentoa ei voi käyttää palvelimen consolista!", --Found in sv_init.lua
	sv9		=		"Tämä pelaaja ei voi varoitettu!", --Found in sv_awarn.lua
	sv10	=		"Pelaajat tässä ryhmässä ei voida varoitettu!", --Found in sv_awarn.lua
   
    sql1    =       "Poistettiin koska saavutti varoitusten rajan", --Found in awarn_sql.lua
    sql2    =       "Bannattiin koska saavutti varoitusten rajan", --Found in awarn_sql.lua
    sql3    =       "Tällä pelaajalla ei ole varoituksia.", --Found in awarn_sql.lua
    sql4    =       "Varoituksia vähennetty 1 pelaajalle:", --Found in awarn_sql.lua
    sql5    =       "Tällä pelaajalla on 0 akviitista varoitusta", --Found in awarn_sql.lua
    sql6    =       "Kaikki varoitukset poistettu pelaajalta", --Found in awarn_sql.lua
    sql7    =       "Tallennetta tälle varoitukselle ei löydy", --Found in awarn_sql.lua
    sql8    =       "Tervetuloa takaisin!", --Found in awarn_sql.lua
    sql9    =       "Tämänhetkiset aktiiviset varoitukset", --Found in awarn_sql.lua
    sql10   =       "Liittyy serveriin", --Found in awarn_sql.lua
    sql11   =       "Kaikki varoitukset", --Found in awarn_sql.lua
}

--[[
	Finnish translation provided by saviorsoldier (http://steamcommunity.com/profiles/76561198057034162)
]]
AWarn.localizations["TR"] = {
    cl1     =       "AWarn Menu", --Found in cl_init.lua
    cl2     =       "Versiyon", --Found in cl_init.lua
    cl3     =       "Daha fazla ayar için sağ tıklayın!", --Found in cl_init.lua
    cl4     =       "Seçilen Oyuncunun Aktif Uyarıları", --Found in cl_init.lua
    cl5     =       "Seçilen Oyuncunun Toplam Uyarıları", --Found in cl_init.lua
    cl6     =       "Ayarlar", --Found in cl_init.lua
    cl7     =       "Uyaran Admin", --Found in cl_init.lua
    cl8     =       "Sebep", --Found in cl_init.lua
    cl9     =       "Sunucu", --Found in cl_init.lua
    cl10    =       "Tarih/Zaman", --Found in cl_init.lua
    cl11    =       "Uyarıyı Sil", --Found in cl_init.lua
    cl12    =       "Panoya Kopyala", --Found in cl_init.lua
    cl13    =       "Uyarı sebebi panoya kopyalandı!", --Found in cl_init.lua
    cl14    =       "Oyuncu İsmi", --Found in cl_init.lua
    cl15    =       "Uyarı", --Found in cl_init.lua
    cl16    =       "Uyarıları Sil", --Found in cl_init.lua
    cl17    =       "Aktif Uyarıları Azalt", --Found in cl_init.lua
    cl18    =       "Uyarılarınız Gösteriliyor!", --Found in cl_init.lua
    cl19    =       "Sizin Aktif Uyarılarınız: ", --Found in cl_init.lua
    cl20    =       "Sizin Toplam Uyarılarınız: ", --Found in cl_init.lua
    cl21    =       "AWarn Uyarı Menüsü", --Found in cl_init.lua
    cl22    =       "Uyarılan Oyuncu: ", --Found in cl_init.lua
    cl23    =       "GONDER", --Found in cl_init.lua
    cl24    =       "IPTAL", --Found in cl_init.lua
    cl25    =       "AWarn Ayar Menüsü", --Found in cl_init.lua
    cl26    =       "AWarn'ın oyuncuları atmasına izin ver (ceza ayar dosyalarında gözükecek)", --Found in cl_init.lua
    cl27    =       "AWarn'ın oyuncuları banlamasına izin ver (ceza ayar dosyalarında gözükecek)", --Found in cl_init.lua
    cl28    =       "Oyuncuların aktif uyarıları zamanla yok olacaktır.", --Found in cl_init.lua
    cl29    =       "Adminlerin birisine uyarı vermesi için geçerli bir sebep girmesi gerekmektedir.", --Found in cl_init.lua
    cl30    =       "Oyuncuların uyarıları AWarn tarafından atılan bandan sonra yenilenmektedir.", --Found in cl_init.lua
    cl31    =       "AWarn hareketlerini log dosyasına girin.", --Found in cl_init.lua
    cl32    =       "Yok Olma Süresi (dakika olarak)", --Found in cl_init.lua
    cl33    =       "Ek ceza yöntemleri/ayarlarını buradan bulabilirsiniz:", --Found in cl_init.lua
    cl34    =       "tarafından uyarıldınız", --Found in cl_init.lua
    cl35    =       "Uyarıldı", --Found in cl_init.lua/sv_init.lua
    cl36    =       "SteamID'yi tırnak içerisinde kaydırmadığınızdan emin olun!", --Found in cl_init.lua/sv_init.lua
    cl37    =       "Oyuncu Bulunamadı!", --Found in cl_init.lua/sv_init.lua

    sv1     =       "Bu komuta erişiminiz bulunmamaktadır.", --Found in sv_init.lua
    sv2     =       "Bu komutla CVar'ı ayarlayamazsınız.", --Found in sv_init.lua
    sv3     =       "ConVar'a pozitif bir değer girmelisiniz.", --Found in sv_init.lua
    sv4     =       "Diğer adminleri uyaramazsınız!", --Found in sv_init.lua
    sv5     =       "Bir sebep girmelisin. Bunu ayarlardan deaktive edebilirsiniz.", --Found in sv_init.lua
    sv6     =       "tarafından uyarıldınız", --Found in sv_init.lua
    sv7     =       "Uyarılarınızı görmek için !warn yazın.", --Found in sv_init.lua/awarn_sql.lua
    sv8     =       "Bu komut sunucu konsolundan çalıştırılamaz.", --Found in sv_init.lua
	sv9		=		"Bu oyuncu uyarılamaz!", --Found in sv_awarn.lua
	sv10	=		"Bu gruptaki oyuncular uyarılamaz!", --Found in sv_awarn.lua

    sql1    =       "uyarı sınırına ulaştığı için atıldı", --Found in awarn_sql.lua
    sql2    =       "uyarı sınırına ulaştığı için banlandı", --Found in awarn_sql.lua
    sql3    =       "Bu oyuncunun kayıtlı bir uyarı yok", --Found in awarn_sql.lua
    sql4    =       "Oyuncudan bir uyarı düşürüldü: ", --Found in awarn_sql.lua
    sql5    =       "Bu oyuncunun 0 uyarısı mevcut.", --Found in awarn_sql.lua
    sql6    =       "Oyuncunun tüm uyarıları silindi.", --Found in awarn_sql.lua
    sql7    =       "Bu uyarı ID'sinin kaydı bulunamadı!", --Found in awarn_sql.lua
    sql8    =       "Sunucuya tekrar hoşgeldiniz!", --Found in awarn_sql.lua
    sql9    =       "Şuanki Aktif Uyarılar", --Found in awarn_sql.lua
    sql10   =       "sunucuya katıldı", --Found in awarn_sql.lua
    sql11   =       "Toplam Uyarılar", --Found in awarn_sql.lua
}


--[[
	German translation provided by Martin (http://steamcommunity.com/id/martin_link/)
]]
AWarn.localizations["DE"] = {
    cl1     =       "AWarn Menu", --Found in cl_init.lua
    cl2     =       "Version", --Found in cl_init.lua
    cl3     =       "Rechts klick für mehr optionen!", --Found in cl_init.lua
    cl4     =       "Aktive Warnungen des Spielers", --Found in cl_init.lua
    cl5     =       "Menge der Warnungen des Spielers", --Found in cl_init.lua
    cl6     =       "Einstellungen", --Found in cl_init.lua
    cl7     =       "Ersteller", --Found in cl_init.lua
    cl8     =       "Grund", --Found in cl_init.lua
    cl9     =       "Server", --Found in cl_init.lua
    cl10    =       "Datum/Uhrzeit", --Found in cl_init.lua
    cl11    =       "Warnung entfernen", --Found in cl_init.lua
    cl12    =       "In Zwischenablage", --Found in cl_init.lua
    cl13    =       "Warngrund in die Zwischenablage kopiert!", --Found in cl_init.lua
    cl14    =       "Spieler", --Found in cl_init.lua
    cl15    =       "Verwarnen", --Found in cl_init.lua
    cl16    =       "Warnungen löschen", --Found in cl_init.lua
    cl17    =       "Warnungen reduzieren", --Found in cl_init.lua
    cl18    =       "Zeige deine verwarnungen!", --Found in cl_init.lua
    cl19    =       "Deine Aktiven verwarnungen: ", --Found in cl_init.lua
    cl20    =       "Deine Gesamten verwarnungen: ", --Found in cl_init.lua
    cl21    =       "AWarn Verwarnungs Menü", --Found in cl_init.lua
    cl22    =       "Verwarnender Spieler: ", --Found in cl_init.lua
    cl23    =       "Bestätigen", --Found in cl_init.lua
    cl24    =       "Abbrechen", --Found in cl_init.lua
    cl25    =       "AWarn Einstellungen", --Found in cl_init.lua
    cl26    =       "AWarn das KICKEN von Spielern erlauben (Definiert in der Betrafungsdatei)", --Found in cl_init.lua
    cl27    =       "AWarn das BANNEN von Spielern erlauben (Definiert in der Betrafungsdatei)", --Found in cl_init.lua
    cl28    =       "Aktive Warnungen zerfallen nach Zeit.", --Found in cl_init.lua
    cl29    =       "Admins müssen einen Grund für verwarnungen angeben.", --Found in cl_init.lua
    cl30    =       "Aktive Warnungen Resetten nach Bann.", --Found in cl_init.lua
    cl31    =       "AWarn Logs erstellen.", --Found in cl_init.lua
    cl32    =       "Verwarnungs zerfall Rate (In Minuten)", --Found in cl_init.lua
    cl33    =       "Zusätzliche Betrafungen können in folgender Datei gefunden werden:", --Found in cl_init.lua
    cl34    =       "wurde verwarnt von", --Found in cl_init.lua
    cl35    =       "verwarnt", --Found in cl_init.lua/sv_init.lua
    cl36    =       "Stelle sicher das sich die SteamID in anführungszeichen befindet!", --Found in cl_init.lua/sv_init.lua
    cl37    =       "Spieler nicht gefunden!", --Found in cl_init.lua/sv_init.lua
   
    sv1     =       "Kein Zugriff auf dieses Kommando.", --Found in sv_init.lua
    sv2     =       "Mit diesem Kommando kann keine CVar gesetzt werden.", --Found in sv_init.lua
    sv3     =       "Dies muss ein positiver Wert sein.", --Found in sv_init.lua
    sv4     =       "Du darfst keine anderen Admins verwarnen.", --Found in sv_init.lua
    sv5     =       "Du musst einen Grund angeben. Dies kannst du in den Einstellungen deaktiveren.", --Found in sv_init.lua
    sv6     =       "Du wurdest verwarnt von", --Found in sv_init.lua
    sv7     =       "Schreibe !warn in den Chat um deine verwarnungen einzusehen.", --Found in sv_init.lua/awarn_sql.lua
    sv8     =       "Dieser Command kann nicht in der Server Konsole ausgeführt werden!", --Found in sv_init.lua
	sv9		=		"Dieser Spieler kann nicht gewarnt werden!", --Found in sv_awarn.lua
	sv10	=		"Die Spieler in dieser Gruppe können nicht gewarnt werden!", --Found in sv_awarn.lua
   
    sql1    =       "wurde gekickt weil er das Verwarnungs Limit erreicht hat", --Found in awarn_sql.lua
    sql2    =       "wurde gebannt weil er das Verwarnungs Limit erreicht hat", --Found in awarn_sql.lua
    sql3    =       "Dieser Spieler hat keine verwarnungen", --Found in awarn_sql.lua
    sql4    =       "Aktive verwarnungen reduziert um 1 für Spieler: ", --Found in awarn_sql.lua
    sql5    =       "Dieser Spieler hat schon 0 Warnungen", --Found in awarn_sql.lua
    sql6    =       "Alle Warnungen gelöscht für", --Found in awarn_sql.lua
    sql7    =       "Keine ID gefunden", --Found in awarn_sql.lua
    sql8    =       "Willkommen zurück auf unserem Server", --Found in awarn_sql.lua
    sql9    =       "Deine Aktiven Warnungen", --Found in awarn_sql.lua
    sql10   =       "betritt den Server", --Found in awarn_sql.lua
    sql11   =       "Gesamten Warnungen", --Found in awarn_sql.lua
}


--[[
	Russian translation provided by Snappi (http://steamcommunity.com/id/snappi_incognito/)
]]
AWarn.localizations["RU"] = {
	cl1		=		"Меню AWarn", --Found in cl_init.lua
	cl2		=		"Версия", --Found in cl_init.lua
	cl3		=		"Кликните ПКМ по игроку для более детальной информации!", --Found in cl_init.lua
	cl4		=		"Активные предупреждения выбранного игрока", --Found in cl_init.lua
	cl5		=		"Все предупреждения выбранного игрока", --Found in cl_init.lua
	cl6		=		"Опции", --Found in cl_init.lua
	cl7		=		"Предупреждение Админ", --Found in cl_init.lua
	cl8		=		"Причина", --Found in cl_init.lua
	cl9		=		"Сервер", --Found in cl_init.lua
	cl10	=		"Дата/Время", --Found in cl_init.lua
	cl11	=		"Удалить предупреждение", --Found in cl_init.lua
	cl12	=		"Скопировать в буфер обмена", --Found in cl_init.lua
	cl13	=		"Причина предупреждения скопирована в буфер обмена!", --Found in cl_init.lua
	cl14	=		"Имя игрока", --Found in cl_init.lua
	cl15	=		"Предупредить", --Found in cl_init.lua
	cl16	=		"Очистить предупреждение", --Found in cl_init.lua
	cl17	=		"Уменьшить активные предупреждения", --Found in cl_init.lua
	cl18	=		"Просмотр ваших предупреждений!", --Found in cl_init.lua
	cl19	=		"Ваши активные предупреждения: ", --Found in cl_init.lua
	cl20	=		"Все ваши  предупреждения: ", --Found in cl_init.lua
	cl21	=		"Меню предупреждений AWarn", --Found in cl_init.lua
	cl22	=		"Warning Player: ", --Found in cl_init.lua
	cl23	=		"ОТПРАВИТЬ", --Found in cl_init.lua
	cl24	=		"ОТМЕНА", --Found in cl_init.lua
	cl25	=		"Меню опций AWarn", --Found in cl_init.lua
	cl26	=		"Разрешить AWarn кикать игроков (установленный в файле конфигураций наказаний)", --Found in cl_init.lua
	cl27	=		"Разрешить AWarn банить игроков (установленный в файле конфигураций наказаний)", --Found in cl_init.lua
	cl28	=		"Активные предупреждения игроков будут удаляться со временем.", --Found in cl_init.lua
	cl29	=		"Админы объязаны писать причину, когда предупреждают кого-либо.", --Found in cl_init.lua
	cl30	=		"Активные предупреждения игроков будут аннулированы после бана через AWarn.", --Found in cl_init.lua
	cl31	=		"Логировать действия AWarn в файл данных.", --Found in cl_init.lua
	cl32	=		"Частота удаления (в минутах)", --Found in cl_init.lua
	cl33	=		"Дополнительные настройки/конфигураци наказаний могут быть найдены в:", --Found in cl_init.lua
	cl34	=		"был предупреждён", --Found in cl_init.lua
	cl35	=		"предупреждён", --Found in cl_init.lua/sv_init.lua
	cl36	=		"steamID должен быть в кавычках!", --Found in cl_init.lua/sv_init.lua
	cl37	=		"Игрок не найден!", --Found in cl_init.lua/sv_init.lua
	
	sv1		=		"У вас нету доступа к этой комманде.", --Found in sv_init.lua
	sv2		=		"Вы не можете установить этот CVar С этой коммандой.", --Found in sv_init.lua
	sv3		=		"Вы должны пережать этому ConVar положительное значение.", --Found in sv_init.lua
	sv4		=		"Вы не можете предупреждать других админов.", --Found in sv_init.lua
	sv5		=		"Вы ДОЛЖНЫ писать причину. Отключить это можно в опциях.", --Found in sv_init.lua
	sv6		=		"Вы были предупреждены", --Found in sv_init.lua
	sv7		=		"Напишите !warn чтобы увидеть список ваших предупреждений.", --Found in sv_init.lua/awarn_sql.lua
	sv8		=		"Эта комманда не может быть выполнена через консоль сервера!", --Found in sv_init.lua
	sv9		=		"Этот игрок не может быть предупреждён!", --Found in sv_awarn.lua
	sv10	=		"Игроки в этой группе не могут быть предупреждены!", --Found in sv_awarn.lua
	
	sql1	=		"был кикнут за достижение порога предупреждений", --Found in awarn_sql.lua
	sql2	=		"был забанен за достижение порога предупреждений", --Found in awarn_sql.lua
	sql3	=		"Этот игрок не имеет предупреждений", --Found in awarn_sql.lua
	sql4	=		"Предупреждение уменьшено на 1 игроку: ", --Found in awarn_sql.lua
	sql5	=		"Этот игрок уже имеет 0 активных предупреждений", --Found in awarn_sql.lua
	sql6	=		"Очищено все предупреждения этого игрока", --Found in awarn_sql.lua
	sql7	=		"Запись с этим id предупреждения не найдена!", --Found in awarn_sql.lua
	sql8	=		"С возвращением!", --Found in awarn_sql.lua
	sql9	=		"Текущие активные предупреждения", --Found in awarn_sql.lua
	sql10	=		"зашел на сервер", --Found in awarn_sql.lua
	sql11	=		"Все предупреждения", --Found in awarn_sql.lua
}

--[[
    French translation provided by Driven (http://steamcommunity.com/profiles/76561197986344922)
]]
 
AWarn.localizations["FR"] = {
    cl1     =       "Menu AWarn", --Found in cl_init.lua
    cl2     =       "Version", --Found in cl_init.lua
    cl3     =       "Clic droit sur un joueur pour plus d'options!", --Found in cl_init.lua
    cl4     =       "Avertos Actifs Joueur Selectionné", --Found in cl_init.lua
    cl5     =       "Avertos Total Joueur Selectionné", --Found in cl_init.lua
    cl6     =       "Options", --Found in cl_init.lua
    cl7     =       "Admin Avertissant", --Found in cl_init.lua
    cl8     =       "Raison", --Found in cl_init.lua
    cl9     =       "Serveur", --Found in cl_init.lua
    cl10    =       "Date/Temps", --Found in cl_init.lua
    cl11    =       "Supprimer l'avertissement", --Found in cl_init.lua
    cl12    =       "Copier au Presse-Papier", --Found in cl_init.lua
    cl13    =       "Raison de l'avertissement copiée au Presse-Papier!", --Found in cl_init.lua
    cl14    =       "Nom du Joueur", --Found in cl_init.lua
    cl15    =       "Avertir", --Found in cl_init.lua
    cl16    =       "Supprimer les avertissements", --Found in cl_init.lua
    cl17    =       "Réduire les avertissements actifs", --Found in cl_init.lua
    cl18    =       "Afficher vos avertissements!", --Found in cl_init.lua
    cl19    =       "Vos avertissements actifs:", --Found in cl_init.lua
    cl20    =       "Vos avertissements total:", --Found in cl_init.lua
    cl21    =       "AWarn Menu Avertos", --Found in cl_init.lua
    cl22    =       "Joueur Averti:", --Found in cl_init.lua
    cl23    =       "ENVOYER", --Found in cl_init.lua
    cl24    =       "ANNULER", --Found in cl_init.lua
    cl25    =       "AWarn Menu Options", --Found in cl_init.lua
    cl26    =       "AWarn peut KICK les joueurs. (défini au fichier réglages de punitions)", --Found in cl_init.lua
    cl27    =       "AWarn peut BAN les joueurs. (défini au fichier réglages de punitions)", --Found in cl_init.lua
    cl28    =       "Les avertissements actifs du joueur se décomposeront au fil du temps.", --Found in cl_init.lua
    cl29    =       "Les admins doivent mettre une raison sur leur avertissements.", --Found in cl_init.lua
    cl30    =       "Les avertissements actifs du joueur sont supprimés après un ban AWarn.", --Found in cl_init.lua
    cl31    =       "Sauvegarder les actions AWarn.", --Found in cl_init.lua
    cl32    =       "Taux de Baisse (en minutes)", --Found in cl_init.lua
    cl33    =       "Les configurations des punitions supplémentaires peuvent être trouvés dans:", --Found in cl_init.lua
    cl34    =       "a été averti par", --Found in cl_init.lua
    cl35    =       "averti", --Found in cl_init.lua/sv_init.lua
    cl36    =       "Assurez-vous de mettre le steamID entre guillemets!", --Found in cl_init.lua/sv_init.lua
    cl37    =       "Joueur introuvable!", --Found in cl_init.lua/sv_init.lua
   
    sv1     =       "Vous n'avez pas accès à cette commande.", --Found in sv_init.lua
    sv2     =       "Vous ne pouvez pas définir cette CVar avec cette commande.", --Found in sv_init.lua
    sv3     =       "Vous devez définir cette ConVar sur une valeur positive.", --Found in sv_init.lua
    sv4     =       "Vous n'êtes pas autorisé à avertir les autres admins.", --Found in sv_init.lua
    sv5     =       "Vous DEVEZ inclure une raison. Désactivez-le dans les options.", --Found in sv_init.lua
    sv6     =       "Vous avez été averti par", --Found in sv_init.lua
    sv7     =       "Tapez !warn pour voir la liste de vos avertissements.", --Found in sv_init.lua/awarn_sql.lua
    sv8     =       "Cette commande ne peut pas être exécuté à partir de la console du serveur!", --Found in sv_init.lua
    sv9     =       "Ce joueur ne peut pas être averti!", --Found in sv_awarn.lua
    sv10    =       "Les joueurs de ce groupe ne peuvent pas être avertis!", --Found in sv_awarn.lua
   
    sql1    =       "a été éjecté pour avoir atteint le seuil d'avertissements", --Found in awarn_sql.lua
    sql2    =       "a été banni pour avoir atteint le seuil d'avertissements", --Found in awarn_sql.lua
    sql3    =       "Ce joueur n'a pas d'avertissement d'enregistré.", --Found in awarn_sql.lua
    sql4    =       "Avertissements réduits de 1 pour le joueur: ", --Found in awarn_sql.lua
    sql5    =       "Ce joueur a déjà 0 avertissement actif", --Found in awarn_sql.lua
    sql6    =       "Tous les avertissements sont supprimés du joueur", --Found in awarn_sql.lua
    sql7    =       "Sauvegarde pour cette avertissement ID introuvable", --Found in awarn_sql.lua
    sql8    =       "Bienvenue sur le serveur", --Found in awarn_sql.lua
    sql9    =       "Avertissements actifs actuel", --Found in awarn_sql.lua
    sql10   =       "joint le serveur", --Found in awarn_sql.lua
    sql11   =       "Avertissements Total", --Found in awarn_sql.lua
}

--[[
    Brazilian Portuguese translation provided by Comedian (http://steamcommunity.com/id/comedinha/)
]]
AWarn.localizations["PT"] = {
    cl1     =       "AWarn Menu", --Found in cl_init.lua
    cl2     =       "Versão", --Found in cl_init.lua
    cl3     =       "Use o botão direito sobre um jogador para mais opções!", --Found in cl_init.lua
    cl4     =       "Advertências ativas do jogador", --Found in cl_init.lua
    cl5     =       "Advertências totais do jogador", --Found in cl_init.lua
    cl6     =       "Opções", --Found in cl_init.lua
    cl7     =       "Responsável", --Found in cl_init.lua
    cl8     =       "Razão", --Found in cl_init.lua
    cl9     =       "Servidor", --Found in cl_init.lua
    cl10    =       "Data/Hora", --Found in cl_init.lua
    cl11    =       "Deletar Aviso", --Found in cl_init.lua
    cl12    =       "Copiar razão", --Found in cl_init.lua
    cl13    =       "Razão de aviso copiada!", --Found in cl_init.lua
    cl14    =       "Nome do Jogador", --Found in cl_init.lua
    cl15    =       "Advertir", --Found in cl_init.lua
    cl16    =       "Limpar advertências", --Found in cl_init.lua
    cl17    =       "Reduzir advertências ativos", --Found in cl_init.lua
    cl18    =       "Mostrando seus advertências!", --Found in cl_init.lua
    cl19    =       "Suas Advertências Ativas: ", --Found in cl_init.lua
    cl20    =       "Seu Total de Advertências: ", --Found in cl_init.lua
    cl21    =       "AWarn Menu de Advertências", --Found in cl_init.lua
    cl22    =       "Advertências de Jogador: ", --Found in cl_init.lua
    cl23    =       "SUBMETER", --Found in cl_init.lua
    cl24    =       "CANCELAR", --Found in cl_init.lua
    cl25    =       "AWarn Menu de Opções", --Found in cl_init.lua
    cl26    =       "Permitir AWarn dar KICK em jogadores (definido no arquivo de definições de punição)", --Found in cl_init.lua
    cl27    =       "Permitir AWarn dar BAN em jogadores (definido no arquivo de definições de punição)", --Found in cl_init.lua
    cl28    =       "Advertências ativos dos jogadores irão cair com o tempo.", --Found in cl_init.lua
    cl29    =       "Administradores são obrigados a apresentar uma razão.", --Found in cl_init.lua
    cl30    =       "Wans ativos serão resetados após fim de banimento via AWarn.", --Found in cl_init.lua
    cl31    =       "Log de Ações AWarn para um arquivo de dados.", --Found in cl_init.lua
    cl32    =       "Tempo de caida (em minutos)", --Found in cl_init.lua
    cl33    =       "Configuações de Punição adicionais/configurações podem ser encontradas em:", --Found in cl_init.lua
    cl34    =       "foi advertido por", --Found in cl_init.lua
    cl35    =       "advertido", --Found in cl_init.lua/sv_init.lua
    cl36    =       "Certifique-se de colocar o steamID em parênteses!", --Found in cl_init.lua/sv_init.lua
    cl37    =       "Player Não Encontrado!", --Found in cl_init.lua/sv_init.lua
   
    sv1     =       "Você não tem acesso a esse comando.", --Found in sv_init.lua
    sv2     =       "Você não pode definir essa CVar com este comando.", --Found in sv_init.lua
    sv3     =       "Você deve colocar esta ConVar com um valor positivo.", --Found in sv_init.lua
    sv4     =       "Você não tem permissão para avisar os outros administradores.", --Found in sv_init.lua
    sv5     =       "Você PRECISA colocar a razão. Desabilite isto nas opções.", --Found in sv_init.lua
    sv6     =       "Você foi avisado por", --Found in sv_init.lua
    sv7     =       "Digite !warn para ver a lista de suas advertências.", --Found in sv_init.lua/awarn_sql.lua
    sv8     =       "Este comando não pode ser executado a partir do console do servidor!", --Found in sv_init.lua
    sv9     =       "Este player não pode receber advertências!", --Found in sv_awarn.lua
    sv10    =       "Players neste grupo não podem ser advertidos!", --Found in sv_awarn.lua
   
    sql1    =       "recebeu kick por atingir o limite de advertências", --Found in awarn_sql.lua
    sql2    =       "foi banido por atingir o limite de advertências", --Found in awarn_sql.lua
    sql3    =       "Este jogador não tem advertências no registro", --Found in awarn_sql.lua
    sql4    =       "Advertências reduzidar em 1 para o jogador: ", --Found in awarn_sql.lua
    sql5    =       "Este jogador tem 0 advertências ativas atualmente", --Found in awarn_sql.lua
    sql6    =       "Limpadas todas as advertências do jogador", --Found in awarn_sql.lua
    sql7    =       "Gravação para este ID de advertência não encontrada", --Found in awarn_sql.lua
    sql8    =       "Bem vindo de volta ao servidor", --Found in awarn_sql.lua
    sql9    =       "Total de Advertências Ativas", --Found in awarn_sql.lua
    sql10   =       "entrou no servidor", --Found in awarn_sql.lua
    sql11   =       "Total de Advertências", --Found in awarn_sql.lua
}