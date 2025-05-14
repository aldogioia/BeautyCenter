class Strings {
  static const String ip = "192.168.1.65";

  static const String log_in = "Accedi";
  static const String register = "Registrati";
  static const String nice_to_see_you_again = "Bello rivederti";
  static const String forgot_your_password = "Password dimenticata?";
  static const String do_not_have_a_password_set_it = "Non hai la password? impostala";
  static const String email = "Email";
  static const String password = "Password";
  static const String name = "Nome";
  static const String surname = "Cognome";
  static const String mobile_phone = "Cellulare";
  static const String confirm_email_forget_password = "Nessun problema, può capitare! Conferma la tua mail e ti invieremo un codice per recuperare la tua password.";
  static const String first_access = "Primo accesso? Imposta la password";
  static const String set_password_screen_text = "Ti verrà inviato il link per impostare la password all’email che inserirai. Assicurati di inserire la stessa email fornita all’amministratore.";
  static const String send_email = "Invia email";
  static const String hello = "Ciao, ";
  static const String search = "Cerca";
  static const String update = "Modifica";
  static const String room = "Stanza";
  static const String ok = "Ok";
  static const String cancel = "Annulla";
  static const String select = "Seleziona";
  static const String services = "Servizi";
  static const String price_in_euro = "Prezzo in €";
  static const String duration_in_minutes = "Durata in minuti";
  static const String add = "Aggiungi";
  static const String write = "Scrivi";
  static const String filter_for = "Filtro per";
  static const String not_booking_for_the_selected_operator = "Non ci sono prenotazioni per l'operatore selezionato";
  static const String no_operators_found = "Nessun operatore trovato";
  static const String at = "alle";
  static const String select_day = "Seleziona un giorno";
  static const String select_operator = "Seleziona un operatore";
  static const String select_hours = "Seleziona un orario";
  static const String select_filter = "Imposta filtro";
  static const String filter_set = "Filtro impostato";
  static const String book = "Prenota";
  static const String next = "Avanti";
  static const String remember_to_arrive_10_minutes_early = "Ricorda di arrivare con 10 minuti di anticipo per non rischiare di perdere l’appuntamento.";
  static const String select_service = "Seleziona un servizio";
  static const String no_services_created = "Nessun servizio creato";
  static const String no_operator_created = "Nessun operatore creato";
  static const String no_room_created = "Nessuna stanza creata";
  static const String no_customer = "Nessun utente disponibile";
  static const String operators = "Operatori";
  static const String rooms = "Stanze";
  static const String customers = "Utenti";
  static const String schedule_exception = "Cambi turno";

  static const String operator = "Operatore";
  static const String service = "Servizio";
  static const String book_service = "Prenota un servizio";
  static const String insert_verification_code = "Inserisci il codice a 5 cifre che abbiamo inviato alla tua mail";
  static const String verify = "Verifica";
  static const String code_verify_error = "Errore nella verifica del codice";
  static const String code_verify_validation_error = 'Il codice deve contenere esattamente 5 numeri.';
  static const String reset_your_password = "Reimposta la tua password";
  static const String reset_password = "Reimposta password";
  static const String show_password = "Mostra password";
  static const String new_password = "Nuova password";
  static const String confirm_password = "Conferma password";
  static const String confirm_password_must_be_equals_to_new_password = "La password di conferma deve essere uguale alla nuova password.";
  static const String name_and_surname = "Nome e cognome";
  static const String schedules = "Turni";
  static const String changes = "Cambi";
  static const String am = "AM";
  static const String pm = "PM";
  static const String save = "Salva";
  static const String morning = "Mattina";
  static const String afternoon = "Pomeriggio";
  static const String start_hours = "Orario inizio";
  static const String end_hours = "Orario fine";
  static const String free = "Libero";
  static const String free_morning = "Mattina libera";
  static const String free_afternoon = "Pomeriggio libero";
  static const String start = "Inizio";
  static const String end = "Fine";
  static const String operator_does_not_have_schedule_exceptions = "L'operatore non ha variazione dei turni";
  static const String plan = "Pianifica";
  static const String period = "Periodo";
  static const String date = "Data";
  static const String date_must_be_after_today = "La data selezionata deve essere successiva alla data odierna";
  static const String back = "Indietro";
  static const String verification_code = "Codice di verifica"; // todo mettere XXXXX ?
  static const String settings = "Impostazioni";
  static const String account = "Account";
  static const String access = "Accesso";
  static const String personal_data = "Dati personali";
  static const String notifications = "Notifiche";
  static const String exit = "Esci";
  static const String delete_account = "Elimina account";

  // errori
  static const String insert_a_valid_email_address_error = "Inserisci un indirizzo email valido";
  static const String invalid_password_error = "La password deve essere lunga tra 8 e 50 caratteri, contenere almeno una lettera maiuscola, numero.";
  static const String invalid_phone_number_error = "Il numero di telefono deve contenere 10 numeri";
  static const String invalid_service_name = "Il nome del servizio non può essere vuoto e può contenere massimo 50 caratteri";
  static const String invalid_duration = "La durata deve essere almeno di un minuto";
  static const String invalid_price = "Il prezzo deve essere almeno di un euro";
  static const String invalid_name = "Il nome deve contenere almeno 3 caratteri e massimo 50";
  static const String invalid_surname = "Il cognome deve contenere almeno 3 caratteri e massimo 50";
  static const String invalid_room_name = "Il nome del servizio non può essere vuoto e può contenere massimo 50 caratteri";
  static const String select_start_date = "Seleziona la data di inizio.";
  static const String start_and_end_times_error = "L'orario di inizio e fine di un turno devono essere inseriti entrambi o nessuno. La data di fine deve essere successiva a quella di inizio";
  static const String afternoon_schedule_before_morning_schedule_error = "Il turno di pomeriggio deve iniziare dopo la fine del turno della mattina";
  static const String end_date_must_be_after_start_date = "La data di fine deve essere successiva a quella di inizio";
  static const String schedule_exteption_start_date_before_today_error = "La data del cambio turno deve essere successiva a quella odierna";
  static const String cannot_do_phone_call = "Impossibile avviare la chiamata: dispositivo non supportato";
  static const String authentication_error = "Errore di autenticazione";

  //http error
  static const String connection_error = "Errore di connessione";

  // update
  static const String customer_updated_successfully = "Utente modificato con successo";
  static const String room_updated_successfully = "Stanza modificata con successo";
  static const String service_updated_successfully = "Servizio modificato con successo";
  static const String operator_updated_successfully = "Operatore modificato con successo";
  static const String change = "Cambia";
  static const String schedule_updated_correctly = "Turno modificato correttamente";

  // create
  static const String service_create_successfully = "Servizio creato con successo";
  static const String operator_create_successfully = "Operatore creato con successo";
  static const String room_create_successfully = "Stanza creata con successo";
  static const String add_service = "Aggiungi servizio";
  static const String add_operator = "Aggiungi operatore";
  static const String add_room = "Aggiungi stanza";
  static const String booking_created_successfully = "Prenotazione effettuata con successo";
  static const String schedule_created_correctly = "Turno creato correttamente";

  // delete
  static const String delete = "Elimina";
  static const String want_to_delete = "Vuoi eliminare";
  static const String service_delete_successfully = "Servizio eliminato con successo";
  static const String room_delete_successfully = "Stanza eliminata con successo";
  static const String operator_delete_successfully = "Operatore eliminato con successo";
  static const String booking_deleted = "Appuntamento cancellato";

  static const String bookings = "Appuntamenti";

}