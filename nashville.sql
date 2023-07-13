select DISTINCT SOLDASVACANT from dbo.Nashville;
select * from dbo.Nashville WHERE OWNERNAME IS  NULL;  --25261
select count(SOLDASVACANT) from dbo.Nashville where SOLDASVACANT=0;

select count(*) from dbo.Nashville where propertyaddress IS NULL order by ParcelID;


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress) from 
dbo.Nashville a
JOIN dbo.Nashville b
ON a.ParcelID=b.ParcelID
AND a.UniqueID<>b.UniqueID
where a.PropertyAddress IS NULL;


UPDATE a
set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  
dbo.Nashville a
JOIN dbo.Nashville b
ON a.ParcelID=b.ParcelID
AND a.UniqueID<>b.UniqueID
where a.PropertyAddress IS NULL;


select PropertyAddress,propertystreet,propertycity from dbo.Nashville;

ALTER TABLE dbo.Nashville
ADD Propertystreet VARCHAR(255);

ALTER TABLE dbo.Nashville
ADD Propertycity VARCHAR(255);

UPDATE dbo.Nashville
SET propertystreet=SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1);

UPDATE dbo.Nashville
SET propertycity=SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1,LEN(PropertyAddress));

select --SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1),
DISTINCT SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1,LEN(PropertyAddress))
--PropertyAddress
from dbo.Nashville;

select OwnerAddress,ownerstreet,Ownercity,Ownerstate from dbo.Nashville where OwnerAddress IS NOT NULL;


ALTER TABLE dbo.Nashville
ADD  Ownerstate VARCHAR(255);
Ownercity VARCHAR(255),
 Ownerstate VARCHAR(255),
;

select 
PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),1),
OWNERADDRESS
from dbo.Nashville;

UPDATE dbo.Nashville
SET ownerstreet =PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
Ownercity=PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
Ownerstate=PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
;

select * from dbo.Nashville WHERE SOLDASVACANT='No'


UPDATE dbo.Nashville
set SOLDASVACANT = CASE WHEN SOLDASVACANT=0 then 'No'
        when  SOLDASVACANT=1 THEN 'Yes'
		ELSE SOLDASVACANT END  ;


ALTER TABLE dbo.Nashville
ALTER COLUMN SOLDASVACANT VARCHAR(50);


with cte_a AS 
(select 
PARCELID,
LANDUSE,
PROPERTYADDRESS,
SALEDATE,
SALEPRICE,
LEGALREFERENCE,
ROW_NUMber() OVER(PARTITION BY PARCELID,LANDUSE,PROPERTYADDRESS,SALEDATE,SALEPRICE,LEGALREFERENCE ORDER BY PARCELID) AS rn
from dbo.Nashville)
select * 
from 
cte_a
where rn>1;

SELECT * FROM dbo.Nashville;

ALTER TABLE dbo.Nashville
DROP COLUMN PROPERTYADDRESS,OWNERADDRESS,TAXDISTRICT;


SELECT * FROM DBO.Nashville;

UPDATE DBO.Nashville
SET Acreage=ROUND(acreage,2);


--56374(TOTAL)


select count(*) from dbo.Nashville where LandValue IS NULL;























