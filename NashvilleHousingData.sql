select * from ProjectPortfolio.dbo.NashvilleHousing

-- Removing Time from SaleDate Column
select SaleDate, CONVERT(Date,SaleDate) 
from ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populating Property Address Data
Select * 
from ProjectPortfolio.dbo.NashvilleHousing
Where PropertyAddress IS NULL

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
Join ProjectPortfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
Join ProjectPortfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Splitting Address into separate columns(Address, City, State)

select * from ProjectPortfolio.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as Address
From ProjectPortfolio.dbo.NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))


-- Splitting Owner Address into Separate columns(Address,City,State) using PARSENAME function

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from ProjectPortfolio.dbo.NashvilleHousing

ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Changing Y and N to Yes and No in "Sold As Vacant" Field using CASE function
select distinct(SoldAsVacant)
From ProjectPortfolio.dbo.NashvilleHousing

select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'YES'
	 When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
From ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	 When SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

-- Remove Duplicates using CTE
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER()OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
From ProjectPortfolio.dbo.NashvilleHousing
)
DELETE
from RowNumCTE
Where row_num > 1

--Deleting Unused Columns

ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate