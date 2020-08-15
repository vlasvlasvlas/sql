

truncate table ENDPOINT_STG_3_OCDS_honducompras_contracts_documents
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_contracts
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_parties
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_planning_budget
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_planning_budget_budgetbreakdown
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_tender
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_tender_documents
go



DECLARE 
	@ocid nvarchar(200),
	@tender_id nvarchar(200);

DECLARE release_ocid CURSOR FOR 
	
	SELECT release_ocid,tender_id FROM ENDPOINT_STG_2_OCDS_honducompras

OPEN release_ocid;

FETCH NEXT FROM release_ocid INTO 
	@ocid,
	@tender_id;

WHILE @@FETCH_STATUS = 0
    BEGIN

		DECLARE @json VARCHAR(MAX)




		-- tender content:
		SET @json = 
		(
			select tender from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)
		-- tender.tenderers


		INSERT into ENDPOINT_STG_3_OCDS_honducompras_tender
		select 
		@ocid as ocid, @tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (
			--resto de las columnas de tender
			-- Tender
			tender_id							varchar(250)	'$.id',
			tender_title						varchar(250)	'$.title',
			tender_statusDetails				varchar(250)	'$.statusDetails',
			tender_status						varchar(150)	'$.status',
			tender_datePublished				DateTime2		'$.datePublished',
			tender_mainProcurementCategory		varchar(150)	'$.mainProcurementCategory',
			tender_procurementMethod			varchar(150)	'$.procurementMethod',
			tender_procurementMethodDetails		varchar(250)	'$.procurementMethodDetails',
			tender_localProcurementCategory		varchar(150)	'$.localProcurementCategory',
			tender_description					varchar(550)	'$.description',
			tender_procuringEntity_id			varchar(150)	'$.procuringEntity.id',
			tender_procuringEntity_name			varchar(150)	'$.procuringEntity.name',

			-- Tender.tenderPeriod
			tender_tenderPeriod_startDate		DateTime2	    '$.tenderPeriod.startDate',
			tender_tenderPeriod_endDate			DateTime2	    '$.tenderPeriod.endDate',

			-- Tender.enquiryPeriod
			tender_enquiryPeriod_startDate		DateTime2	    '$.enquiryPeriod.startDate',
			tender_enquiryPeriod_endDate		DateTime2	    '$.enquiryPeriod.endDate',

			-- legalBasis
			legalBasis_id						varchar(150)	'$.legalBasis.id',
			legalBasis_scheme					varchar(150)	'$.legalBasis.scheme',
			legalBasis_description				varchar(150)	'$.legalBasis.description',

			--nestedjson
			tenderers					NVARCHAR(MAX)	AS JSON
		) as a

		CROSS APPLY
		OPENJSON(a.tenderers)
		WITH
		(
			tenderers_id				varchar(50)		'$.id',
			tenderers_name				varchar(150)	'$.name'
		) AS b



		
		-- tender.documents

		INSERT into ENDPOINT_STG_3_OCDS_honducompras_tender_documents
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (
			documents						NVARCHAR(MAX)	AS JSON
		) as a
		CROSS APPLY
		OPENJSON(a.documents)
		WITH
		(
			documents_id					bigint			'$.id',
			documents_title					varchar(150)	'$.title',
			documents_description			varchar(550)	'$.description',
			documents_documentType			varchar(150)	'$.documentType',
			documents_format				varchar(150)	'$.format',
			documents_url					varchar(150)	'$.url',
			documents_datePublished			varchar(150)	'$.datePublished'

		) AS c







		
		-- parties content
		SET @json = 
		(
			select top 1 parties from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)
		-- parties

		
		INSERT into ENDPOINT_STG_3_OCDS_honducompras_parties
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (

			parties_id							varchar(150)	'$.id',
			parties_name						varchar(150)	'$.name',
			parties_contactPoint_name			varchar(150)	'$.contactPoint.name',
			parties_contactPoint_email			varchar(150)	'$.contactPoint.email',
			parties_contactPoint_telephone		varchar(150)	'$.contactPoint.telephone',
			parties_contactPoint_faxNumber		varchar(150)	'$.contactPoint.faxNumber',
			parties_contactPoint_url			varchar(150)	'$.contactPoWint.url',
			parties_address_region				varchar(150)	'$.address.region',
			parties_address_locality			varchar(150)	'$.address.locality',
			parties_address_streetAddress		varchar(150)	'$.address.streetAddress',
			parties_identifier_id				varchar(150)	'$.identifier.id',
			parties_identifier_scheme			varchar(150)	'$.identifier.scheme',
			parties_memberOf_id					varchar(150)	'$.memberOf.id',
			parties_memberOf_scheme				varchar(150)	'$.memberOf.name',
			roles								NVARCHAR(MAX)	AS JSON

		) as a
	


		-- planning
		SET @json = 
		(
			select top 1 planning from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)

		
		INSERT into ENDPOINT_STG_3_OCDS_honducompras_planning_budget
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (

			budget	NVARCHAR(MAX)	AS JSON

		) as a


		CROSS APPLY
		OPENJSON(a.budget)
		WITH
		(
			budget_id					varchar(50)		'$.id',
			budget_description			varchar(150)	'$.description',
			budget_amount_amount		varchar(150)	'$.amount.amount',
			budget_amount_currency		float			'$.amount.currency'

		) AS b




		--budget.budgetBreakdown:
		SET @json = 
		(
			select top 1 budgetBreakdown from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)


		INSERT into ENDPOINT_STG_3_OCDS_honducompras_planning_budget_budgetbreakdown
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (

			budget_budgetBreakdown_sourceParty_id			varchar(150)	'$.sourceParty.id',
			budget_budgetBreakdown_sourceParty_name			varchar(150)	'$.sourceParty.name',

			budget_budgetBreakdown_period_startDate			varchar(150)	'$.period.startDate',
			budget_budgetBreakdown_period_endDate			varchar(150)	'$.period.endDate',

			budget_budgetBreakdown_period_id					varchar(50)		'$.id',
			budget_budgetBreakdown_period_description			varchar(150)	'$.description',
			budget_budgetBreakdown_period_amount_amount			varchar(150)	'$.amount.amount',
			budget_budgetBreakdown_period_amount_currency		float			'$.amount.currency'

		) as a







		--contracts
		SET @json = 
		(
			select top 1 contracts from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)


		INSERT into ENDPOINT_STG_3_OCDS_honducompras_contracts
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (

			contracts_id							varchar(150)	'$.id',			
			contracts_title							varchar(150)	'$.title',
			contracts_description					varchar(150)	'$.description',

			contracts_buyer_id						varchar(150)	'$.buyer.id',
			contracts_buyer_name					varchar(150)	'$.buyer.name',

			contracts_dateSigned					varchar(150)	'$.dateSigned',
			contracts_value_currency				varchar(150)	'$.value.currency',
			contracts_value_amount					varchar(150)	'$.value.amount',

			contracts_awardID						varchar(150)	'$.awardID',
			contracts_localProcurementCategory		varchar(150)	'$.localProcurementCategory',
			documents								NVARCHAR(MAX)	AS JSON,
			suppliers								NVARCHAR(MAX)	AS JSON

		) as a

		CROSS APPLY
		OPENJSON(a.suppliers)
		WITH
		(
			suppliers_name				varchar(150)	'$.name',
			suppliers_id				varchar(150)	'$.id'

		) AS c






		--contracts DOCUMENTS
		SET @json = 
		(
			select top 1 contracts from ENDPOINT_STG_2_OCDS_honducompras where release_ocid = @ocid and tender_id = @tender_id 
		)


		insert into ENDPOINT_STG_3_OCDS_honducompras_contracts_documents
		select 
		@ocid as ocid,@tender_id as tenderid,
		*
		
		FROM OPENJSON ( @json ) 
		WITH (

			contracts_id							varchar(150)	'$.id',			
			contracts_title							varchar(150)	'$.title',
			contracts_description					varchar(150)	'$.description',
			documents								NVARCHAR(MAX)	AS JSON

		) as a

		CROSS APPLY
		OPENJSON(a.documents)
		WITH
		(
			documents_title				varchar(150)	'$.title',
			documents_format			varchar(150)	'$.format',
			documents_description		varchar(150)	'$.description',
			documents_url				varchar(150)	'$.url',
			documents_documentType		varchar(150)	'$.documentType',
			documents_datePublished		varchar(150)	'$.datePublished',
			documents_id				varchar(150)	'$.id'

		) AS b


        FETCH NEXT FROM release_ocid INTO @ocid,@tender_id;
    END;

CLOSE release_ocid;
DEALLOCATE release_ocid;
go




/*
SELECT TOP 10 * FROM ENDPOINT_STG_3_OCDS_honducompras_contracts
go
SELECT TOP 10 * FROM ENDPOINT_STG_3_OCDS_honducompras_contracts_documents
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_parties
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_planning_budget
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_planning_budget_budgetbreakdown
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_tender
go
truncate table ENDPOINT_STG_3_OCDS_honducompras_tender_documents
go
*/

