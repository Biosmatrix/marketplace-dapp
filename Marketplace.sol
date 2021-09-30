// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Product {
        uint256 id;
        string name;
        string description;
        string brand;
        string _type;
        string condition;
        string color;
        string thumbnail;
        string[] images;
        uint256 price;
        string[] categories;
        uint256 posted;
        string location;
    }

    // Electronics | Vehicles | Fashion | Services
    struct Category {
        string name;
    }

    struct Seller {
        address id;
        string email;
        string phone;
        string location;
        uint256[] productIds;
    }

    Product[] private products;
    mapping(address => Seller) private sellers;

    function createAd(
        uint256 _price,
        string memory _name,
        string memory _description,
        string memory _brand,
        string memory _type,
        string memory _condition,
        string memory _color,
        string memory _location,
        string memory _thumbnail,
        string[] memory _images,
        string[] memory _categories
    ) public {
        require(bytes(_name).length > 0, "Product Name must not be Empty.");
        require(_categories.length > 0, "At least 1 category is required");

        uint256 productId = products.length;

        Product memory newProduct = Product({
            id: productId,
            price: _price,
            name: _name,
            description: _description,
            brand: _brand,
            _type: _type,
            condition: _condition,
            color: _color,
            location: _location,
            thumbnail: _thumbnail,
            images: _images,
            categories: _categories,
            posted: block.timestamp
        });

        products.push(newProduct);

        sellers[msg.sender].productIds.push(productId);
    }

    function getProduct(uint256 _productId)
        external
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            string[] memory,
            uint256
        )
    {
        require(
            _productId < products.length && _productId > 0,
            "No product found"
        );
        return (
            products[_productId].id,
            products[_productId].name,
            products[_productId].description,
            products[_productId].thumbnail,
            products[_productId].categories,
            products[_productId].price
        );
    }

    function getAds() public view returns (Product[] memory _products) {
        return products;
    }

    function getTotalAds() external view returns (uint256) {
        return products.length;
    }
}
