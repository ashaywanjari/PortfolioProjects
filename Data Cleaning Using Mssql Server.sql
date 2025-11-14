SELECT * from PorfolioProject..NashvilleHousing

-- Standardize Date Format 
Select SaleDateConverted, CONVERT(Date, SaleDate)
from PorfolioProject..NashvilleHousing

Update NashvilleHousing set
SaleDate = CONVERT(Date, SaleDate)

Alter Table NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing 
set SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address Data 
Select *
From PorfolioProject..NashvilleHousing
-- where PropertyAddress IS NULL
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
From PorfolioProject..NashvilleHousing a
Join PorfolioProject..NashvilleHousing b
     on a.ParcelID =b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress IS NULL

 Update a
 SET PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
 From PorfolioProject..NashvilleHousing a
 Join PorfolioProject..NashvilleHousing b
      on a.ParcelID =b.ParcelID
     AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress IS NULL

 -- Breaking Out Address Into Individual columns(Address, City, State)
 Select PropertyAddress
From PorfolioProject..NashvilleHousing

SELECT 
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address
, Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) As Address
From PorfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertSplitCity  NVARCHAR(255)

Update NashvilleHousing
SET PropertSplitCity = Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
From PorfolioProject.. NashvilleHousing   
  

SELECT OwnerAddress
From PorfolioProject.. NashvilleHousing   
  


Select 
PARSENAME(REPLACE (OwnerAddress,',','.'), 3),
PARSENAME(REPLACE (OwnerAddress,',','.'), 2),
PARSENAME(REPLACE (OwnerAddress,',','.'), 1)
From PorfolioProject.. NashvilleHousing   

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity  NVARCHAR(255)

Update NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE (OwnerAddress,',','.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState  NVARCHAR(255)

Update NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE (OwnerAddress,',','.'), 1)

SELECT *
From PorfolioProject.. NashvilleHousing  



-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProject..NashvilleHousing
Group by SoldAsVacant
Order By 2

Select SoldAsVacant
, Case when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
       Else SoldAsVacant
       END
From PorfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
       Else SoldAsVacant
       END

Case when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
       Else SoldAsVacant
       END


--- Remove Duplicates 
WITH RowNumCTE AS(
Select *,
       ROW_NUMBER()over(PARTITION BY ParcelID,
                        PropertyAddress,
                        SalePrice,
                        SaleDate,
                        LegalReference
                        ORDER BY 
                               UniqueID) row_num
From PorfolioProject..NashvilleHousing
-- Order by ParcelID
)
Delete 
From RowNumCTE
Where row_num >1
-- Order By PropertyAddress


WITH RowNumCTE AS(
Select *,
       ROW_NUMBER()over(PARTITION BY ParcelID,
                        PropertyAddress,
                        SalePrice,
                        SaleDate,
                        LegalReference
                        ORDER BY 
                               UniqueID) row_num
From PorfolioProject..NashvilleHousing
-- Order by ParcelID
)
Select * 
From RowNumCTE
Where row_num >1
Order By PropertyAddress





select *
From PorfolioProject..NashvilleHousing


-- Delete Unused Columns 


select *
From PorfolioProject..NashvilleHousing



Alter Table PorfolioProject..NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate