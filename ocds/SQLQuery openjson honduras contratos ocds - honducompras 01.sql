

/*
--http://www.contratacionesabiertas.gob.hn/proceso/ocds-lcuori-orvkNL-LPN%20No.01-2020-SEAF-UNAH-2/
--http://www.contratacionesabiertas.gob.hn/proveedor/HN-RTN-080119005459150/?paginaCon=1&paginarPorCon=5&paginaPag=1&paginarPorPag=5&paginaPro=1&paginarPorPro=5
--https://standard.open-contracting.org/latest/en/schema/release/
--https://standard.open-contracting.org/latest/en/schema/reference/#package-metadata
*/

drop table ENDPOINT_STG_2_OCDS_honducompras
go

drop procedure SP_JSON_OCDS_HONDUCOMPRAS_1
go

create procedure SP_JSON_OCDS_HONDUCOMPRAS_1 as 
---------------------------------------
--1 ENDPOINT_STG_2_Json2Table_contratos

DECLARE @json VARCHAR(MAX)

SET @json = (
	select top 1
	jsontext
	from 
	ENDPOINT_STG_1_JsonFromWs
	where post = 'HonduCompras'
	order by modificationDate desc
)

BEGIN


	SELECT

	-- url original (release package)
	'http://200.13.162.79/datosabiertos/HC1/HC1_datos_2020.json' as urljson,
	'Honducompras' as datasource,

	--package
	a.package_publisher_name,
	a.package_uri,
	a.package_publicationPolicy,
	a.package_version,
	a.package_publishedDate,
	a.package_license,

	-- releases
	b.release_ocid,
	b.release_id,
	b.release_date,
	b.release_initiationType,
	b.buyer_id,
	b.buyer_name,

	-- NESTED ARRAYS:
	-- Parties:
	-- describing the buyers, suppliers, economic operators, and other participants in a contracting process.
	-- Each of the parties (organizations or other participants) referenced in a release must be included in the parties section.
	b.parties,

	-- Planning:
	-- describe the background to a contracting process. This can include details of the budget
	b.planning,

	-- Tender (licitacion)
	-- details of a forthcoming process to receive and evaluate proposals to supply these goods and services
	-- details of a completed tender process, including details of bids received.
	b.tender,

	-- Awards (adjudicacion)
	-- used to announce any awards issued for this tender. 
	b.awards,

	-- Contracts (Contratos)
	-- details of contracts that have been entered into. Every contract must have a related award.
	b.contracts,

	-- Tags (etiquetas)
	-- Tags can be used to filter releases [a,b,c]
	b.tag,

	--nested ids:
	c.id as tender_id,
	d.id as awards_id,

	-- SourcesOpen
	e.sources_id,
	e.sources_name,
	e.sources_url,

	g.budgetBreakdown

	INTO  ENDPOINT_STG_2_OCDS_honducompras

	FROM OPENJSON ( @json ) 
	WITH 
		(

			--package
			package_publisher_name 			nvarchar(255)	'$.publisher.name',
			package_uri						nvarchar(255)	'$.uri',
			package_publicationPolicy		VARCHAR(255)	'$.publicationPolicy',
			package_version					VARCHAR(255)	'$.version',
			package_publishedDate			DateTime2		'$.publishedDate',
			package_license					varchar(255)	'$.license',

			--releases
			releases						NVARCHAR(MAX)	AS JSON

		) as a

CROSS APPLY
	OPENJSON(a.releases)
	WITH
		(
			release_ocid						varchar(255)	'$.ocid', --Open Contracting ID
			release_id							varchar(255)	'$.id', --Release ID
			release_date						DateTime2		'$.date', --Release Date
			release_initiationType				varchar(150)	'$.initiationType', --Initiation type

			-- Buyer object:
			-- A buyer is an entity whose budget will be used to pay for goods, works or services related to a contract. 
			-- This may be different from the procuring entity who may be specified in the tender data.
			buyer_id							varchar(150)	'$.buyer.id',
			buyer_name							varchar(150)	'$.buyer.name',










			-- Planning object:
			-- The planning section can be used to describe the background to a contracting process. 
			-- This can include details of the budget from which funds are drawn, or related projects for this contracting process. 
			-- Background documents such as a needs assessment, feasibility study and project plan can also be included in this section.
			planning							NVARCHAR(MAX)	AS JSON, 

			--Parties:
			--Information on the parties (organizations, economic operators and other participants) 
			--who are involved in the contracting process and their roles, e.g. buyer, procuring entity, supplier etc.
			parties								NVARCHAR(MAX)	AS JSON, 
	
			-- Tender:
			-- The activities undertaken in order to enter into a contract.
			tender								NVARCHAR(MAX)	AS JSON, 
	
			-- Awards:
			-- Information from the award phase of the contracting process.
			-- There can be more than one award per contracting process e.g. because the contract is split among different providers, or because it is a standing offer.
			awards								NVARCHAR(MAX)	AS JSON,

			-- Contracts:
			--Information from the contract creation phase of the procurement process.
			contracts							NVARCHAR(MAX)	AS JSON,

			-- Release Tag:
			-- Tags can be used to filter releases and to understand the kind of information that releases might contain.
			tag									NVARCHAR(MAX)	AS JSON,

			-- Sources
			sources								NVARCHAR(MAX)	AS JSON

		) b

	
	--id tender
	CROSS APPLY
	OPENJSON(b.tender)
	WITH
		(
		id		varchar(255)	'$.id' --Tender ID
		) c

	-- id awards
	CROSS APPLY
	OPENJSON(b.awards)
	WITH
		(
		id		varchar(255)	'$.id' --awards ID
		) d

	CROSS APPLY
	OPENJSON(b.sources)
	WITH
		(
			sources_id							varchar(50)		'$.id',
			sources_name						varchar(150)	'$.name',
			sources_url							varchar(250)	'$.url'
		) AS e

	CROSS APPLY
	OPENJSON(b.planning)
	WITH
		(
			budget				NVARCHAR(MAX)	AS JSON
		) AS f


	CROSS APPLY
	OPENJSON(f.budget)
	WITH
		(
			budgetBreakdown		NVARCHAR(MAX)	AS JSON
		) AS g




WHERE ISJSON( @json ) > 0;

END
go


EXEC SP_JSON_OCDS_HONDUCOMPRAS_1
go


select top 20 * from ENDPOINT_STG_2_OCDS_honducompras where planning is not null

/*
planning_budget_id
planning_budget_description
planning_budget_description_amount
planning_budget_description_currency

--arrays2open planning
planning_budget_budgetBreakdown						NVARCHAR(MAX)	AS JSON, 
planning_documents									NVARCHAR(MAX)	AS JSON, 
planning_milestones									NVARCHAR(MAX)	AS JSON, 

*/
