<cfsilent>
<cfprocessingdirective pageencoding="utf-8">
<!---
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckfinder.com/license

 Defines the object, for the Polish language. This is the base file for all translations.
--->
<cfscript>
CKFLang = structNew();
	CKFLang.ErrorUnknown = 'Wykonanie operacji zakończyło się niepowodzeniem. (Błąd %1)';
	CKFLang.Errors = ArrayNew(1);
	CKFLang.Errors[10] = 'Nieprawidłowe polecenie (command).';
	CKFLang.Errors[11] = 'Brak wymaganego parametru: źródło danych (type).';
	CKFLang.Errors[12] = 'Nieprawidłowe źródło danych (type).';
	CKFLang.Errors[102] = 'Nieprawidłowa nazwa pliku lub katalogu.';
	CKFLang.Errors[103] = 'Wykonanie operacji nie jest możliwe: brak autoryzacji.';
	CKFLang.Errors[104] = 'Wykonanie operacji nie powiodło się z powodu niewystarczających uprawnień do systemu plików.';
	CKFLang.Errors[105] = 'Nieprawidłowe rozszerzenie.';
	CKFLang.Errors[109] = 'Nieprawiłowe polecenie.';
	CKFLang.Errors[110] = 'Niezidentyfikowany błąd.';
	CKFLang.Errors[115] = 'Plik lub katalog o podanej nazwie już istnieje.';
	CKFLang.Errors[116] = 'Nie znaleziono ktalogu. Odśwież panel i spróbuj ponownie.';
	CKFLang.Errors[117] = 'Nie znaleziono pliku. Odśwież listę plików i spróbuj ponownie.';
	CKFLang.Errors[118] = 'Ścieżki źródłowa i docelowa są jednakowe.';
	CKFLang.Errors[201] = 'Plik o podanej nazwie już istnieje. Nazwa przesłanego pliku została zmieniona na "%1"';
	CKFLang.Errors[202] = 'Nieprawidłowy plik.';
	CKFLang.Errors[203] = 'Nieprawidłowy plik. Plik przekroczył dozwolony rozmiar.';
	CKFLang.Errors[204] = 'Przesłany plik jest uszkodzony.';
	CKFLang.Errors[205] = 'Brak folderu tymczasowego na serwerze do przesyłania plików.';
	CKFLang.Errors[206] = 'Przesyłanie pliku zakończyło się niepowodzeniem z powodów bezpieczeństwa. Plik zawiera dane przypominające HTML.';
	CKFLang.Errors[207] = 'Nazwa przesłanego pliku została zmieniona na "%1"';
	CKFLang.Errors[300] = 'Przenoszenie nie powiodło się.';
	CKFLang.Errors[301] = 'Kopiowanie nie powiodo się.';
	CKFLang.Errors[500] = 'Menedżer plików jest wyłączony z powodów bezpieczeństwa. Skontaktuj się z administratorem oraz sprawdź plik konfiguracyjny CKFindera.';
	CKFLang.Errors[501] = 'Tworzenie miniaturek jest wyłączone.';
</cfscript>
</cfsilent>
