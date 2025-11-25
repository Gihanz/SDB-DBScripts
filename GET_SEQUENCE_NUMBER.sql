CREATE PROCEDURE SDB.GET_SEQUENCE_NUMBER
	(IN pcyear VARCHAR(15),OUT out_seq_num INTEGER)
	LANGUAGE SQL
	MODIFIES SQL DATA

	P1: BEGIN 

	DECLARE count1  INTEGER; 
	DECLARE var_seq_num INTEGER; 
	DECLARE var_pcyyyy VARCHAR(15);
	
	LOCK TABLE SDB.APP_SEQUENCE IN EXCLUSIVE MODE;
 	SELECT COUNT(*) INTO count1 from SDB.APP_SEQUENCE where PCYYYY = pcyear;
  
	IF(count1 <> 0) Then
		
		SELECT PCYYYY INTO var_pcyyyy FROM SDB.APP_SEQUENCE where PCYYYY = pcyear;
		IF(var_pcyyyy = pcyear) Then
		SELECT SEQUENCE_NUMBER+1 INTO var_seq_num FROM SDB.APP_SEQUENCE where PCYYYY = pcyear;
		update SDB.APP_SEQUENCE set SEQUENCE_NUMBER = var_seq_num where PCYYYY = pcyear;

		ELSE
		set var_seq_num = 1;
		update SDB.APP_SEQUENCE set SEQUENCE_NUMBER = var_seq_num  where PCYYYY = pcyear;

		END IF;
		 
	ELSE
	set var_seq_num = 1;
	insert into SDB.APP_SEQUENCE(PCYYYY, SEQUENCE_NUMBER, CREATED) values(pcyear, var_seq_num, CURRENT TIMESTAMP);     

	END IF;
	commit;
set out_seq_num = var_seq_num;
END P1
