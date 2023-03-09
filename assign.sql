USE INFINITY_055_001;
GO

--SELECT  	
--		b.BR_CODE ,
--		b.BR_NAME, 
--		lb.LOCAL_BODY_CODE,
--		lb.LOCAL_BODY_NAME, 
--		d.DISTRICT_CODE, 
--		d.DISTRICT_NAME, 
--		d.STATE_ID, 
--		s.STATE_NAME
--FROM dbo.BRANCH b
--		INNER JOIN dbo.local_body lb
--			ON b.DIST_CODE = lb.DISTRICT_CODE
--		INNER JOIN dbo.district d
--			ON b.DIST_CODE = d.DISTRICT_CODE
--		INNER JOIN dbo.STATE s
--			ON d.STATE_ID = s.STATE_CODE
--GO
-------------------------------------------------------------------------------------------

SELECT DISTINCT
       CONCAT(d.STATE_ID, ' - ', s.STATE_NAME) Province,
       CONCAT(b.BR_CODE, ' - ', b.BR_NAME) Branch,
       CONCAT(d.DISTRICT_CODE, ' - ', d.DISTRICT_NAME) District,
       ISNULL(m.No_of_Members, 0) Members,
       ISNULL(l.No_of_Loanee, 0) Loanee,
	   loan.LoanOutstanding,
	   depo.Deposit,
	   profit.TotalProfit
	   
FROM dbo.BRANCH b
    INNER JOIN dbo.local_body lb
        ON b.DIST_CODE = lb.DISTRICT_CODE
    INNER JOIN dbo.district d
        ON b.DIST_CODE = d.DISTRICT_CODE
    INNER JOIN dbo.STATE s
        ON d.STATE_ID = s.STATE_CODE
----- No Of Members -----
    INNER JOIN
    (
        SELECT B.BR_CODE,
               COUNT(DISTINCT CM.CUSTOMER_CODE) No_of_Members
        FROM dbo.CUSTOMER_MAST CM
            INNER JOIN
            (
                SELECT CUSTOMER_CODE,
                       BR_CODE,
                       STATUS_CODE,
                       ROW_NUMBER() OVER (PARTITION BY CUSTOMER_CODE
                                          ORDER BY STATUS_CHG_DATE DESC,
                                                   TRAN_ID DESC
                                         ) RN
                FROM dbo.CUST_STATUS_HIST
            ) CSH
                ON CSH.RN = 1
                   AND CSH.CUSTOMER_CODE = CM.CUSTOMER_CODE
                   AND CSH.STATUS_CODE = '02'
            INNER JOIN dbo.BRANCH B
                ON B.BR_CODE = CSH.BR_CODE
        GROUP BY B.BR_CODE
    ) m
        ON b.BR_CODE = m.BR_CODE
----- No Of Loanee -----
    LEFT OUTER JOIN
    (
        SELECT LM.BR_CODE,
               COUNT(DISTINCT D.CUSTOMER_CODE) No_of_Loanee
        FROM dbo.LOAN_MAST LM
            INNER JOIN
            (
                SELECT AHHM.TRAN_ID,
                       AHHM.AC_NO,
                       AHHM.BR_CODE,
                       ROW_NUMBER() OVER (PARTITION BY AHHM.BR_CODE,
                                                       AHHM.AC_NO
                                          ORDER BY AHHM.EFFECT_DATE DESC,
                                                   AHHM.TRAN_ID DESC
                                         ) RN
                FROM dbo.AC_HOLDER_HIST_MAST AHHM
                WHERE AHHM.APPROVED = 'YES'
                      AND AHHM.EFFECT_DATE <= GETDATE()
            ) M
                ON M.RN = 1
                   AND M.AC_NO = LM.AC_NO
                   AND M.BR_CODE = LM.BR_CODE
            INNER JOIN
            (
                SELECT AHHD.TRAN_ID,
                       AHHD.CUSTOMER_CODE,
                       AHHD.BR_CODE,
                       ROW_NUMBER() OVER (PARTITION BY AHHD.BR_CODE, AHHD.TRAN_ID ORDER BY AHHD.TRAN_ID) RN
                FROM dbo.AC_HOLDER_HIST_DETL AHHD
            ) D
                ON D.RN = 1
                   AND M.TRAN_ID = D.TRAN_ID
                   AND M.BR_CODE = D.BR_CODE
        WHERE LM.LOAN_STATUS = '02'
        GROUP BY LM.BR_CODE
    ) l
        ON l.BR_CODE = b.BR_CODE
----- Deposit -----
	INNER JOIN (
					SELECT GD.BR_CODE, SUM(GD.AMT) Deposit
					FROM dbo.GLTRAN_DETL GD
								INNER JOIN dbo.AC_GROUP_GL_MAP AGGL
									ON GD.GL_CODE = AGGL.GL_CODE
								INNER JOIN dbo.GL_NAMED_AC GNA
									ON AGGL.NAMED_AC_CODE = GNA.NAMED_AC_CODE
					WHERE GNA.NAMED_AC_CODE = '0301'
					GROUP BY GD.BR_CODE
				) depo
		ON b.BR_CODE = depo.BR_CODE
----- Loan Outstanding -----
	INNER JOIN (
					SELECT GD.BR_CODE, SUM(GD.AMT)*-1 LoanOutstanding
					FROM dbo.GLTRAN_DETL GD
								INNER JOIN dbo.AC_GROUP_GL_MAP AGGL
									ON GD.GL_CODE = AGGL.GL_CODE
								INNER JOIN dbo.GL_NAMED_AC GNA
									ON AGGL.NAMED_AC_CODE = GNA.NAMED_AC_CODE
					WHERE GNA.NAMED_AC_CODE = '0401'
					GROUP BY GD.BR_CODE
				) loan
		ON b.BR_CODE = loan.BR_CODE
----- Profit -----
	INNER JOIN (
					SELECT GD.BR_CODE, SUM(CASE WHEN AC.GL_TYPE = 'I' THEN GD.AMT
												ELSE (GD.AMT *-1) 
											END) TotalProfit
					FROM dbo.GLTRAN_DETL GD
							INNER JOIN dbo.AC_CHART AC
								ON GD.GL_CODE = AC.GL_CODE
					WHERE AC. GL_TYPE IN ('I', 'E')
					GROUP BY GD.BR_CODE
				) profit
		ON b.BR_CODE = profit.BR_CODE
ORDER BY Branch;
