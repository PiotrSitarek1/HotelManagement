# HotelManagement

Opis
Projekt zakłada stworzenie systemu pozwalającego na zarządzanie siecią hoteli. Aplikacja pozwala użytkownikom na przegląd hoteli i rezerwacje pobytów, a administratorom na wprowadzanie zmian, zarządzanie i kontrole rezerwacji. 


Role 
Admin -  możliwość wszystkiego 
User – możliwość przeglądania i rezerwacji pobytu
Nadzorca – ‘’opieka’’ nad danym hotelem – dodawanie i edycja hotelu, pokoi i usług 


Funkcjonalności 
1.	Logowanie 
  a.	Logowanie istniejących użytkowników
  b.	Rejestracja nowych użytkowników
    i.	‘Nadzorca’ przy rejestracji musi dodać nowy hotel i go skonfigurować
    ii.	Konto ‘Nadzorcy’ musi zostać aktywowane przez ‘Admina’
  c.	Odzyskiwanie hasła
2.	Rezerwacje (User)
  a.	Wgląd w hotele, pokoje i usługi oferowane przez dany hotel (np. basen, siłownia)
  b.	Informacje pokoju – typ, cena, numer, standard, dostępność
  c.	Informacje hotelu – nazwa, adres, kontakt, zdjęcie poglądowe
  d.	Zarezerwowanie pobytu 
3.	Przegląd rezerwacji użytkownika (User)
  a.	Stare rezerwacje 
  b.	Aktualne rezerwacje i ich status
  c.	Możliwość anulowania rezerwacji
4.	Edycja danych profilowych (User)
5.	Edycja informacji o hotelu (Nadzorca)
  a.	Edycja hotelu, pokoi i usług
  b.	Lista rezerwacji – potwierdzanie rezerwacji użytkowników
  c.	Wgląd w historie rezerwacji danego hotelu

Założenia
1.	Nadzorca sprawuje opiekę nad maksymalnie jednym hotelem
2.	Rezerwacji nie można anulować później niż dwa dni przed jej rozpoczęciem 
3.	Brak płatności w aplikacji – rezerwacja przez użytkownika -> płatność po prywatnym kontakcie z Nadzorca (poprzez podanie numeru rezerwacji) -> potwierdzenie rezerwacji w aplikacji przez Nadzorcę
