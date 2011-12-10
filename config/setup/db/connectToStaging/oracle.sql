DROP TABLE tadstats PURGE;
CREATE PUBLIC SYNONYM tadstats FOR muradb.tadstats;
   
DROP TABLE tclassextenddatauseractivity PURGE;
CREATE PUBLIC SYNONYM tclassextenddatauseractivity FOR muradb.tclassextenddatauseractivity;
 
DROP TABLE temailreturnstats PURGE;
CREATE PUBLIC SYNONYM temailreturnstats FOR muradb.temailreturnstats;
 
DROP TABLE temails PURGE;
CREATE PUBLIC SYNONYM temails FOR muradb.temails;
 
DROP TABLE temailstats PURGE;
CREATE PUBLIC SYNONYM temailstats FOR muradb.temailstats;

DROP TABLE tformresponsepackets PURGE;
CREATE PUBLIC SYNONYM tformresponsepackets FOR muradb.tformresponsepackets;
    
DROP TABLE tformresponsequestions PURGE;
CREATE PUBLIC SYNONYM tformresponsequestions FOR muradb.tformresponsequestions;
     
DROP TABLE tsessiontracking PURGE;
CREATE PUBLIC SYNONYM tsessiontracking FOR muradb.tsessiontracking; 
       
DROP TABLE tuseraddresses PURGE; 
CREATE PUBLIC SYNONYM tuseraddresses FOR muradb.tuseraddresses;
   
DROP TABLE tusers PURGE; 
CREATE PUBLIC SYNONYM tusers FOR muradb.tusers;

DROP TABLE tuserremotesessions PURGE; 
CREATE PUBLIC SYNONYM tuserremotesessions FOR muradb.tuserremotesessions;

DROP TABLE tuserstrikes PURGE; 
CREATE PUBLIC SYNONYM tuserstrikes FOR muradb.tuserstrikes;

DROP TABLE tuserstags PURGE;
CREATE PUBLIC SYNONYM tuserstags FOR muradb.tuserstags;

DROP TABLE tclassextend PURGE;
CREATE PUBLIC SYNONYM tclassextend FOR muradb.tclassextend;

DROP TABLE tclassextendsets PURGE;
CREATE PUBLIC SYNONYM tclassextendsets FOR muradb.tclassextendsets;

DROP TABLE tclassextendattributes PURGE;
CREATE PUBLIC SYNONYM tclassextendattributes FOR muradb.tclassextendattributes;

DROP TABLE tplugins PURGE;
CREATE PUBLIC SYNONYM tplugins FOR muradb.tplugins;

COMMIT;

