-- 1. Create Enums
CREATE TYPE active_status AS ENUM ('active', 'inactive');
CREATE TYPE address_type AS ENUM ('home', 'office', 'others');

-- 2. Create Trigger Function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP; -- This now perfectly matches the column name
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Create Customers Table
CREATE TABLE IF NOT EXISTS customers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    account_status active_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP 
);

-- 4. Attach Trigger to Customers
CREATE TRIGGER customers_updated_at_trigger
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- 5. Create Addresses Table
CREATE TABLE addresses (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type address_type NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    postal_code VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_addresses_customers FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
);

-- 6. Attach Trigger to Addresses 
CREATE TRIGGER addresses_updated_at_trigger
BEFORE UPDATE ON addresses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- 7. Create Product Category Table
CREATE TABLE categories (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    parent_category INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_category_parent FOREIGN KEY (parent_category) REFERENCES categories(id) ON DELETE SET NULL
);

-- 8. Attach Trigger to Categories
CREATE TRIGGER categories_updated_at_trigger
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- 9. Create Product Table
CREATE TABLE products (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    sku VARCHAR(255) UNIQUE NOT NULL,
    price DECIMAL(10, 2),
    category INT,
    product_status active_status NOT NULL DEFAULT 'active',
    additional_product_attributes JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_category FOREIGN KEY (category) REFERENCES categories(id) ON DELETE SET NULL
);

-- 8. Attach Trigger to products
CREATE TRIGGER products_updated_at_trigger
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();


-- 9. Create Inventory Table
Create TABLE inventory (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product INT NOT NULL,
    available_quantity INT NOT NULL DEFAULT 0,
    reserved_quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product FOREIGN KEY (product) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_positive_available CHECK (available_quantity >= 0),
    CONSTRAINT chk_positive_reserved CHECK (reserved_quantity >= 0)
);

-- 10. Attach Trigger to inventory
CREATE TRIGGER inventory_updated_at_trigger
BEFORE UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();