--CLEANING DATA IN SQL QUERIES

SELECT * from NashvilleHousing
----STANDARDIZE DATA FORMAT
select SaleDate, convert(date, SaleDate)
from NashvilleHousing

Update NashvilleHousing
SET SaleDateConverted = convert(date, SaleDate)

ALTER TABLE NashVilleHousing
ADD SaleDateConverted Date


----Populate Property address data

select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 from NashvilleHousing  a
join NashvilleHousing b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is  null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing  a
join NashvilleHousing b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]


----Breaking out address into individual columns
--This SQL code selects two substrings from the 'PropertyAddress' column of the 'NashvilleHousing' table.

--The first substring extracts characters from the beginning of 'PropertyAddress' until the first comma (,).
--The second substring extracts characters from the position after the first comma until the end of 'PropertyAddress'.
--These substrings represent different parts of the property address: the first one typically extracts the street address, while the second one extracts additional address details such as city, state, and ZIP code
select PropertyAddress
 from NashvilleHousing
 --
 SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
        ,SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as Address
 from NashvilleHousing

 Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE NashVilleHousing
ADD PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE NashVilleHousing
ADD PropertySplitCity Nvarchar(255);

-----Seperating owner address into sections just like we did in the propertyadress, but by using more simple method
SELECT * FROM NashvilleHousing

SELECT OwnerAddress
FROM NashvilleHousing

SELECT PARSENAME(REPLACE (OwnerAddress,',','.'), 3) AS AddressSection1 ,
PARSENAME(REPLACE (OwnerAddress,',','.'), 2)AS CitySection,
PARSENAME(REPLACE (OwnerAddress,',','.'), 1) AS AddressSection2
from NashvilleHousing

ALTER TABLE NashVilleHousing
ADD OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress,',','.'), 3) 

ALTER TABLE NashVilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress,',','.'), 2) 

ALTER TABLE NashVilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE (OwnerAddress,',','.'), 1) 

SELECT * FROM NashvilleHousing

------CHANGE Y and N to YES and NO in 'sold as vacant' field


SELECT DISTINCT(SoldAsVacant),	Count(SoldAsVacant) FROM NashvilleHousing
Group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' then 'YES'
WHEN SoldAsVacant = 'N' then 'NO'
ELSE SoldAsVacant
END
FROM NashvilleHousing


UPDATE NashvilleHousing 
SET SoldAsVacant =
CASE 
WHEN SoldAsVacant = 'Y' then 'YES'
WHEN SoldAsVacant = 'N' then 'NO'
ELSE SoldAsVacant
END

SELECT DISTINCT(SoldAsVacant),	Count(SoldAsVacant) FROM NashvilleHousing
Group by SoldAsVacant
order by 2


--------REMOVE DUPLICATES
---USING CTE AND WINDOWS FUCNTION TO FIND THE DUPLICATE VALUES
WITH RowNumCTE AS(
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueID
) row_num
FROM NashvilleHousing
)
select *  FROM RowNumCTE
Where row_num>1
order by PropertyAddress


-----DELETE UNUSED COLUMNS

SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP Column OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE NashvilleHousing
DROP Column SaleDate








