DROP TABLE tadstats;
CREATE VIEW tadstats AS SELECT * FROM muradb.tadstats;
   
DROP TABLE tclassextenddatauseractivity;
CREATE VIEW tclassextenddatauseractivity AS SELECT * FROM muradb.tclassextenddatauseractivity;
 
DROP TABLE temailreturnstats;
CREATE VIEW temailreturnstats AS SELECT * FROM muradb.temailreturnstats;
 
DROP TABLE temails;
CREATE VIEW temails AS SELECT * FROM muradb.temails;
 
DROP TABLE temailstats;
CREATE VIEW temailstats AS SELECT * FROM muradb.temailstats;

DROP TABLE tformresponsepackets;
CREATE VIEW tformresponsepackets AS SELECT * FROM muradb.tformresponsepackets;
    
DROP TABLE tformresponsequestions;
CREATE VIEW tformresponsequestions AS SELECT * FROM muradb.tformresponsequestions;
     
DROP TABLE tsessiontracking;
CREATE VIEW tsessiontracking AS SELECT * FROM muradb.tsessiontracking; 
       
DROP TABLE tuseraddresses; 
CREATE VIEW tuseraddresses AS SELECT * FROM muradb.tuseraddresses;
   
DROP TABLE tusers; 
CREATE VIEW tusers AS SELECT * FROM muradb.tusers;

DROP TABLE tuserremotesessions; 
CREATE VIEW tuserremotesessions AS SELECT * FROM muradb.tuserremotesessions;

DROP TABLE tuserstrikes; 
CREATE VIEW tuserstrikes AS SELECT * FROM muradb.tuserstrikes;

DROP TABLE tuserstags;
CREATE VIEW tuserstags AS SELECT * FROM muradb.tuserstags;

DROP TABLE tclassextend;
CREATE VIEW tclassextend AS SELECT * FROM muradb.tclassextend;

DROP TABLE tclassextendsets;
CREATE VIEW tclassextendsets AS SELECT * FROM muradb.tclassextendsets;

DROP TABLE tclassextendattributes;
CREATE VIEW tclassextendattributes AS SELECT * FROM muradb.tclassextendattributes;

DROP TABLE tplugins;
CREATE VIEW tplugins AS SELECT * FROM muradb.tplugins;