CREATE TABLE ubezpiecz_wynik (
    ID_ubezpieczenia INT PRIMARY KEY AUTO_INCREMENT,
    ID_klienta INT NOT NULL,
    ID_samochodu INT NOT NULL,
    cena_bazowa_zl DECIMAL(10,2),
    cena_po_rabatach_zl DECIMAL(10,2),
    CONSTRAINT fk_klient FOREIGN KEY (ID_klienta) REFERENCES clients(id) ON DELETE CASCADE,
    CONSTRAINT fk_samochod FOREIGN KEY (ID_samochodu) REFERENCES car(id) ON DELETE CASCADE
);


INSERT INTO ubezpiecz_wynik (ID_klienta, ID_samochodu, cena_bazowa_zl, cena_po_rabatach_zl)
SELECT 
    c.id AS ID_klienta,
    car.id AS ID_samochodu,

    -- CENA BAZOWA wg rocznika
    CASE 
        WHEN car.rok BETWEEN 2000 AND 2015 THEN 2500
        WHEN car.rok BETWEEN 1980 AND 1990 THEN 2200
        WHEN car.rok BETWEEN 1940 AND 1979 THEN 1300
        ELSE 3000 
    END AS cena_bazowa_zl,

    -- OSTATECZNA CENA po rabatach i dopłatach
    (
        CASE 
            WHEN car.rok BETWEEN 2000 AND 2015 THEN 2500
            WHEN car.rok BETWEEN 1980 AND 1990 THEN 2200
            WHEN car.rok BETWEEN 1940 AND 1979 THEN 1300
            ELSE 3000
        END
        *
        (1 
            - CASE WHEN c.country IN ('Polska','Chiny','Poland','China') THEN 0.30 ELSE 0 END
            + CASE WHEN c.email LIKE '%apple%' THEN 0.40 ELSE 0 END
        )
        *
        (1 - (0.05 * (SELECT COUNT(*) - 1 FROM car WHERE client_id = c.id)))
    ) AS cena_po_rabatach_zl

FROM car
JOIN clients c ON car.client_id = c.id;

