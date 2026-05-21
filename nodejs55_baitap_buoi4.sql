-- //Tạo bảng users
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100)
);

-- //Tạo bảng restaurants
CREATE TABLE restaurants (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(100),
    image VARCHAR(255),
    description TEXT
);

-- //Tạo bảng foods
CREATE TABLE foods (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100),
    image VARCHAR(255),
    price FLOAT,
    description TEXT
);

-- //Tạo bảng likes_res
CREATE TABLE likes_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    PRIMARY KEY(user_id, res_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

-- //Tạo bảng rates_res
CREATE TABLE rates_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    PRIMARY KEY(user_id, res_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
);

-- //Tạo bảng orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(50),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id)
);

-- //Insert dữ liệu mẫu
INSERT INTO users(full_name, email, password)
VALUES
('Nguyen Van A', 'a@gmail.com', '123'),
('Tran Van B', 'b@gmail.com', '123'),
('Le Van C', 'c@gmail.com', '123'),
('Pham Van D', 'd@gmail.com', '123'),
('Hoang Van E', 'e@gmail.com', '123');

INSERT INTO restaurants(res_name, image, description)
VALUES
('KFC', 'kfc.jpg', 'Ga ran'),
('Lotteria', 'lotte.jpg', 'Fast food'),
('McDonald', 'mc.jpg', 'Burger');

INSERT INTO likes_res(user_id, res_id, date_like)
VALUES
(1,1,NOW()),
(1,2,NOW()),
(1,3,NOW()),
(2,1,NOW()),
(2,2,NOW()),
(3,1,NOW());

INSERT INTO foods(food_name, image, price, description)
VALUES
('Burger', 'burger.jpg', 50, 'Burger bo'),
('Pizza', 'pizza.jpg', 120, 'Pizza hai san'),
('Chicken', 'chicken.jpg', 80, 'Ga ran');

INSERT INTO orders(user_id, food_id, amount, code, arr_sub_id)
VALUES
(1,1,2,'ORD001',''),
(1,2,1,'ORD002',''),
(2,1,5,'ORD003',''),
(2,3,2,'ORD004',''),
(3,2,1,'ORD005','');


-- // Câu 1: Tìm 5 người đã like nhà hàng nhiều nhất
-- // Đếm số lần like theo user
-- // GROUP BY user
-- // ORDER BY giảm dần
-- // LIMIT 5
SELECT 
    u.user_id,
    u.full_name,
    COUNT(lr.res_id) AS total_like
FROM users u
JOIN likes_res lr 
ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_like DESC
LIMIT 5;

-- // Câu 2: Tìm 2 nhà hàng có lượt like nhiều nhất
-- // Đếm số user like theo nhà hàng
SELECT 
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS total_like
FROM restaurants r
JOIN likes_res lr
ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_like DESC
LIMIT 2;

-- // Câu 3: Tìm người đã đặt hàng nhiều nhất
-- // Đếm số order hoặc tổng số món đã đặt
SELECT 
    u.user_id,
    u.full_name,
    SUM(o.amount) AS total_food_ordered
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_food_ordered DESC
LIMIT 1;

-- // Câu 4: Người dùng không hoạt động
-- // Người không đặt hàng, like, đánh giá
-- // Ta cần tìm user:
-- // KHÔNG tồn tại trong orders
-- // KHÔNG tồn tại trong likes_res
-- // KHÔNG tồn tại trong rates_res
-- // Sử dụng: LEFT JOIN + IS NULL hoặc NOT EXISTS
SELECT 
    u.user_id,
    u.full_name
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id

LEFT JOIN likes_res lr
ON u.user_id = lr.user_id

LEFT JOIN rates_res rr
ON u.user_id = rr.user_id

WHERE 
    o.user_id IS NULL
    AND lr.user_id IS NULL
    AND rr.user_id IS NULL;
