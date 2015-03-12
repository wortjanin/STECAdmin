-- Log in under the SYS user.
-- !! CREATE USER STEC_<The abbreviation of your University (e.g. PETRSU)> IDENTIFIED BY ....
ALTER SESSION SET CURRENT_SCHEMA=<the name of the user, created just above>;
-- ALTER SESSION SET CURRENT_SCHEMA=STEC_PETRSU;

-- !! DO NOT ALTER THE SESSION UNTIL THE END of the schema loading, ALL THE DATA ARE CREATED IN THE CURRENT ONE.

-- !!! DO NOT CHANGE THE SCHEMA NAME, e.g. <the name of the user, created just above>, 
-- !!! UNTILL ALL STEC USERS of THE SCHEME ARE DISCONNECTED, IN ORDER TO PREVENT hard database errors
