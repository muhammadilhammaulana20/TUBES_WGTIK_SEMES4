# Klasifikasi Nasabah Bank Menggunakan Regresi Logistik

## 1. Deskripsi Proyek

Proyek ini menggunakan bahasa pemrograman R untuk melakukan klasifikasi nasabah bank berdasarkan dataset `bank.csv`. Tujuan utama proyek ini adalah memprediksi apakah seorang nasabah akan melakukan deposit atau tidak.

Metode yang digunakan adalah regresi logistik. Metode ini sesuai karena variabel target berbentuk biner, yaitu:

- `yes`: nasabah melakukan deposit
- `no`: nasabah tidak melakukan deposit

Tahapan utama dalam kode terdiri dari:

1. Load library
2. Load dataset
3. Pemeriksaan awal data
4. Visualisasi Exploratory Data Analysis atau EDA
5. Preprocessing data
6. Split data training dan testing
7. Pembuatan model regresi logistik
8. Prediksi
9. Evaluasi model dengan confusion matrix, metrik evaluasi, ROC Curve, dan AUC

## 2. Identitas Anggota Kelompok

| No | Nama Anggota | NIM |
|---:|---|---:|
| 1 | Muhammad Ilham Maulana | 103102400018 |
| 2 | Dhana Zeta Pangertu | 103102400064 |
| 3 | Muhammad Ade Sulistiansyah | 103102400045 |
| 4 | Muhammad Alfayyadh Nezzati Qosim | 103102400029 |

## 3. Dataset

Dataset yang digunakan adalah `bank.csv`.

Informasi dataset:

| Keterangan | Nilai |
|---|---:|
| Jumlah baris | 11.162 |
| Jumlah kolom | 17 |
| Missing value | 0 |
| Variabel target | `deposit` |
| Metode model | Regresi logistik |

Dataset berisi data nasabah bank, seperti usia, pekerjaan, status pernikahan, pendidikan, saldo, pinjaman, jenis kontak, durasi panggilan, riwayat kampanye, dan keputusan deposit.

## 4. Daftar Variabel Dataset

| Variabel | Penjelasan |
|---|---|
| `age` | Usia nasabah |
| `job` | Jenis pekerjaan nasabah |
| `marital` | Status pernikahan nasabah |
| `education` | Tingkat pendidikan nasabah |
| `default` | Status gagal bayar kredit |
| `balance` | Saldo nasabah |
| `housing` | Status pinjaman rumah |
| `loan` | Status pinjaman pribadi |
| `contact` | Jenis kontak komunikasi |
| `day` | Tanggal kontak terakhir dalam bulan tersebut |
| `month` | Bulan kontak terakhir |
| `duration` | Durasi panggilan dalam detik |
| `campaign` | Jumlah kontak selama kampanye saat ini |
| `pdays` | Jumlah hari sejak kontak kampanye sebelumnya |
| `previous` | Jumlah kontak sebelum kampanye saat ini |
| `poutcome` | Hasil kampanye pemasaran sebelumnya |
| `deposit` | Target, apakah nasabah melakukan deposit atau tidak |

## 5. Struktur File

Pastikan file berada dalam satu folder kerja.

```text
project-folder/
├── bank.csv
├── Regresi Logistik.r
└── README.md
```

## 6. Cara Menjalankan Program di R atau RStudio

### A. Buka RStudio

Buka aplikasi RStudio. Setelah itu, buka file kode R bernama `codingan (1).r`.

### B. Pastikan file dataset berada di folder yang sama

File `bank.csv` harus berada di folder yang sama dengan file kode R. Hal ini penting karena kode membaca dataset dengan perintah berikut:

```r
df <- read.csv("bank.csv", stringsAsFactors = FALSE)
```

Jika file dataset berada di folder berbeda, atur folder kerja terlebih dahulu dengan perintah:

```r
setwd("lokasi/folder/project")
```

Contoh pada Windows:

```r
setwd("D:/Kuliah/ProjectBank")
```

### C. Install library jika belum tersedia

Jalankan perintah berikut di Console R:

```r
install.packages("ggplot2")
install.packages("dplyr")
install.packages("caret")
install.packages("pROC")
install.packages("gridExtra")
```

### D. Jalankan script

Program dapat dijalankan dengan salah satu cara berikut:

1. Klik tombol `Source` di RStudio.
2. Blok seluruh kode, lalu klik `Run`.
3. Jalankan dari Console dengan perintah:

```r
source("codingan (1).r")
```

## 7. Penjelasan Library

Kode menggunakan lima library utama.

```r
library(ggplot2)
library(dplyr)
library(caret)
library(pROC)
library(gridExtra)
```

| Library | Fungsi |
|---|---|
| `ggplot2` | Membuat grafik visualisasi data |
| `dplyr` | Mengolah data, seperti menghitung, mengelompokkan, dan mengubah kolom |
| `caret` | Membagi data training dan testing serta mengevaluasi model |
| `pROC` | Membuat ROC Curve dan menghitung nilai AUC |
| `gridExtra` | Menggabungkan beberapa plot dalam satu tampilan |

## 8. Load Data dan Pemeriksaan Awal

Kode:

```r
df <- read.csv("bank.csv", stringsAsFactors = FALSE)

cat("Jumlah baris  :", nrow(df), "\n")
cat("Jumlah kolom  :", ncol(df), "\n")
cat("Missing value :", sum(is.na(df)), "\n\n")
summary(df)
```

### Penjelasan kode

`read.csv()` digunakan untuk membaca dataset `bank.csv`.

`stringsAsFactors = FALSE` digunakan agar data teks tidak otomatis diubah menjadi factor saat dibaca.

`nrow(df)` menghitung jumlah baris.

`ncol(df)` menghitung jumlah kolom.

`sum(is.na(df))` menghitung jumlah missing value.

`summary(df)` menampilkan ringkasan statistik untuk setiap variabel.

### Output

```text
Jumlah baris  : 11162
Jumlah kolom  : 17
Missing value : 0
```

### Interpretasi output

Output menunjukkan bahwa dataset memiliki 11.162 data dan 17 variabel. Tidak terdapat missing value, sehingga data dapat langsung dilanjutkan ke tahap eksplorasi dan preprocessing.

## 9. Distribusi Target Deposit

Kode:

```r
cat("Distribusi Deposit:\n")
print(prop.table(table(df$deposit)) * 100)
```

### Penjelasan kode

`table(df$deposit)` menghitung jumlah data pada setiap kategori target.

`prop.table()` mengubah jumlah tersebut menjadi proporsi.

Dikali 100 agar hasilnya menjadi persen.

### Output

| Deposit | Jumlah | Persentase |
|---|---:|---:|
| no | 5.873 | 52,62% |
| yes | 5.289 | 47,38% |

### Interpretasi output

Jumlah nasabah yang tidak melakukan deposit sedikit lebih banyak dibandingkan nasabah yang melakukan deposit. Perbedaannya tidak terlalu jauh, sehingga target dataset cukup seimbang untuk digunakan dalam klasifikasi.

## 10. Visualisasi EDA

EDA atau Exploratory Data Analysis digunakan untuk memahami pola awal data sebelum model dibuat.

### 10.1 Plot 1: Distribusi Deposit

Kode:

```r
p1 <- ggplot(df, aes(x = deposit, fill = deposit)) +
  geom_bar(width = 0.5) +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 1. Distribusi Target (Deposit)",
       x = "Deposit", y = "Jumlah") +
  theme_minimal() + theme(legend.position = "none")
```

### Fungsi kode

`ggplot()` membuat objek grafik.

`aes(x = deposit, fill = deposit)` berarti sumbu X berisi kategori deposit dan warna grafik mengikuti kategori deposit.

`geom_bar()` membuat grafik batang.

`geom_text()` menampilkan angka jumlah data di atas batang.

`scale_fill_manual()` mengatur warna untuk kategori `yes` dan `no`.

`labs()` memberi judul grafik dan label sumbu.

`theme_minimal()` membuat tampilan grafik lebih bersih.

### Output

Output berupa grafik batang yang menunjukkan jumlah nasabah dengan deposit `yes` dan `no`.

Nilai yang muncul:

| Deposit | Jumlah |
|---|---:|
| no | 5.873 |
| yes | 5.289 |

### Interpretasi output

Grafik menunjukkan bahwa kategori `no` lebih banyak daripada `yes`. Namun, selisihnya tidak terlalu besar. Hal ini membantu model karena data target tidak terlalu timpang.

### 10.2 Plot 2: Usia vs Deposit

Kode:

```r
p2 <- ggplot(df, aes(x = deposit, y = age, fill = deposit)) +
  geom_boxplot() +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 2. Usia vs Deposit",
       x = "Deposit", y = "Usia") +
  theme_minimal() + theme(legend.position = "none")
```

### Fungsi kode

Kode ini membuat boxplot untuk membandingkan usia nasabah berdasarkan status deposit.

`geom_boxplot()` digunakan untuk melihat nilai tengah, sebaran data, dan outlier.

### Output

| Deposit | Median Usia | Rata-rata Usia | Usia Minimum | Usia Maksimum |
|---|---:|---:|---:|---:|
| no | 39 | 40,84 | 18 | 89 |
| yes | 38 | 41,67 | 18 | 95 |

### Interpretasi output

Median usia nasabah deposit `yes` dan `no` hampir sama. Namun, rata-rata usia pada kategori `yes` sedikit lebih tinggi. Artinya, usia memiliki hubungan dengan keputusan deposit, tetapi perbedaannya tidak terlalu besar jika hanya dilihat dari median.

### 10.3 Plot 3: Saldo vs Deposit

Kode:

```r
p3 <- ggplot(df, aes(x = deposit, y = balance, fill = deposit)) +
  geom_boxplot(outlier.alpha = 0.3) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  coord_cartesian(ylim = c(-500, 8000)) +
  labs(title = "Gambar 3. Saldo vs Deposit",
       x = "Deposit", y = "Saldo (EUR)") +
  theme_minimal() + theme(legend.position = "none")
```

### Fungsi kode

Kode ini membuat boxplot untuk membandingkan saldo nasabah berdasarkan status deposit.

`coord_cartesian(ylim = c(-500, 8000))` membatasi tampilan sumbu Y dari -500 sampai 8000. Tujuannya agar grafik lebih mudah dibaca karena terdapat outlier saldo yang sangat tinggi.

### Output

| Deposit | Median Saldo | Rata-rata Saldo | Saldo Minimum | Saldo Maksimum |
|---|---:|---:|---:|---:|
| no | 414 | 1.280,23 | -6.847 | 66.653 |
| yes | 733 | 1.804,27 | -3.058 | 81.204 |

### Interpretasi output

Nasabah yang melakukan deposit memiliki median saldo lebih tinggi dibandingkan nasabah yang tidak melakukan deposit. Median saldo pada kategori `yes` adalah 733, sedangkan kategori `no` adalah 414. Artinya, saldo dapat menjadi salah satu variabel yang berhubungan dengan keputusan deposit.

### 10.4 Plot 4: Durasi Panggilan vs Deposit

Kode:

```r
p4 <- ggplot(df, aes(x = deposit, y = duration, fill = deposit)) +
  geom_boxplot(outlier.alpha = 0.3) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 4. Durasi Panggilan vs Deposit",
       x = "Deposit", y = "Durasi (detik)") +
  theme_minimal() + theme(legend.position = "none")
```

### Fungsi kode

Kode ini membuat boxplot untuk melihat hubungan antara durasi panggilan dan keputusan deposit.

Sumbu X menunjukkan status deposit.

Sumbu Y menunjukkan durasi panggilan dalam detik.

Warna grafik dibedakan berdasarkan kategori deposit.

`outlier.alpha = 0.3` membuat titik outlier lebih transparan.

### Output

| Deposit | Median Durasi | Rata-rata Durasi | Durasi Minimum | Durasi Maksimum |
|---|---:|---:|---:|---:|
| no | 163 detik | 223,13 detik | 2 detik | 3.284 detik |
| yes | 426 detik | 537,29 detik | 8 detik | 3.881 detik |

### Interpretasi output

Nasabah dengan deposit `yes` memiliki durasi panggilan lebih lama. Median durasi untuk kategori `yes` adalah 426 detik, sedangkan kategori `no` adalah 163 detik.

Artinya, semakin lama percakapan antara pihak bank dan nasabah, peluang nasabah melakukan deposit cenderung lebih besar.

Catatan penting: variabel `duration` baru diketahui setelah panggilan selesai. Jika model digunakan untuk prediksi sebelum panggilan dilakukan, variabel ini dapat menimbulkan data leakage.

### 10.5 Menampilkan Plot 1 sampai Plot 4

Kode:

```r
grid.arrange(p1, p2, p3, p4, ncol = 2)
```

### Fungsi kode

`grid.arrange()` digunakan untuk menggabungkan empat grafik dalam satu tampilan.

`ncol = 2` berarti grafik disusun menjadi dua kolom.

### Output

Output berupa satu halaman visualisasi yang berisi:

1. Distribusi deposit
2. Usia vs deposit
3. Saldo vs deposit
4. Durasi panggilan vs deposit

### Interpretasi output

Gabungan grafik ini memudahkan pembacaan pola data. Pengguna dapat melihat perbandingan beberapa variabel terhadap keputusan deposit dalam satu tampilan.

### 10.6 Plot 5: Proporsi Deposit Berdasarkan Pekerjaan

Kode:

```r
df %>%
  count(job, deposit) %>%
  group_by(job) %>%
  mutate(pct = n / sum(n)) %>%
  ggplot(aes(x = reorder(job, pct), y = pct, fill = deposit)) +
  geom_bar(stat = "identity") + coord_flip() +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Gambar 5. Proporsi Deposit berdasarkan Pekerjaan",
       x = "Pekerjaan", y = "Proporsi") +
  theme_minimal()
```

### Fungsi kode

`count(job, deposit)` menghitung jumlah nasabah berdasarkan kombinasi pekerjaan dan status deposit.

`group_by(job)` mengelompokkan data berdasarkan pekerjaan.

`mutate(pct = n / sum(n))` menghitung proporsi deposit pada setiap pekerjaan.

`ggplot()` membuat grafik.

`geom_bar(stat = "identity")` membuat grafik batang berdasarkan nilai proporsi yang sudah dihitung.

`coord_flip()` membalik grafik menjadi horizontal agar nama pekerjaan lebih mudah dibaca.

`scale_y_continuous(labels = scales::percent_format())` mengubah nilai proporsi menjadi persen.

### Output

Output berupa grafik batang horizontal yang menunjukkan proporsi deposit berdasarkan pekerjaan.

Proporsi deposit `yes` berdasarkan pekerjaan:

| Pekerjaan | Jumlah Yes | Proporsi Yes |
|---|---:|---:|
| student | 269 | 74,72% |
| retired | 516 | 66,32% |
| unemployed | 202 | 56,58% |
| management | 1.301 | 50,70% |
| unknown | 34 | 48,57% |
| admin. | 631 | 47,30% |
| self-employed | 187 | 46,17% |
| technician | 840 | 46,08% |
| services | 369 | 39,98% |
| housemaid | 109 | 39,78% |
| entrepreneur | 123 | 37,50% |
| blue-collar | 708 | 36,42% |

### Interpretasi output

Pekerjaan dengan proporsi deposit `yes` tertinggi adalah `student`, yaitu 74,72%. Posisi berikutnya adalah `retired` sebesar 66,32% dan `unemployed` sebesar 56,58%.

Pekerjaan dengan proporsi deposit `yes` terendah adalah `blue-collar`, yaitu 36,42%.

Artinya, pekerjaan nasabah memiliki hubungan dengan kecenderungan melakukan deposit.

## 11. Preprocessing Data

Kode:

```r
df_model <- df %>%
  mutate(
    deposit   = as.integer(deposit == "yes"),
    default   = as.integer(default == "yes"),
    housing   = as.integer(housing == "yes"),
    loan      = as.integer(loan == "yes"),
    education = case_when(education == "primary"   ~ 1,
                          education == "secondary" ~ 2,
                          education == "tertiary"  ~ 3, TRUE ~ 0),
    prev_contact = as.integer(pdays != -1),
    month    = match(tolower(month),
                     c("jan","feb","mar","apr","may","jun",
                       "jul","aug","sep","oct","nov","dec")),
    job      = as.integer(factor(job)),
    marital  = as.integer(factor(marital)),
    contact  = as.integer(factor(contact)),
    poutcome = as.integer(factor(poutcome))
  ) %>% select(-pdays)
```

### Fungsi preprocessing

Preprocessing digunakan untuk mengubah data mentah menjadi data numerik. Model regresi logistik membutuhkan input numerik, sehingga variabel teks harus dikodekan terlebih dahulu.

### 11.1 Mengubah target deposit

Kode:

```r
deposit = as.integer(deposit == "yes")
```

Output:

| Nilai Awal | Nilai Baru |
|---|---:|
| no | 0 |
| yes | 1 |

Jumlah data:

| Deposit Baru | Makna | Jumlah |
|---:|---|---:|
| 0 | Tidak deposit | 5.873 |
| 1 | Deposit | 5.289 |

### 11.2 Mengubah default, housing, dan loan

Kode:

```r
default = as.integer(default == "yes")
housing = as.integer(housing == "yes")
loan    = as.integer(loan == "yes")
```

Output:

| Variabel | Nilai 0 | Nilai 1 |
|---|---:|---:|
| default | 10.994 | 168 |
| housing | 5.881 | 5.281 |
| loan | 9.702 | 1.460 |

Interpretasi:

- Nilai 0 berarti `no`
- Nilai 1 berarti `yes`

### 11.3 Mengubah education

Kode:

```r
education = case_when(education == "primary"   ~ 1,
                      education == "secondary" ~ 2,
                      education == "tertiary"  ~ 3, TRUE ~ 0)
```

Output:

| Kode | Pendidikan | Jumlah |
|---:|---|---:|
| 0 | unknown | 497 |
| 1 | primary | 1.500 |
| 2 | secondary | 5.476 |
| 3 | tertiary | 3.689 |

Interpretasi:

Pendidikan diubah menjadi angka karena memiliki tingkatan. Nilai 0 digunakan untuk data pendidikan yang tidak diketahui.

### 11.4 Membuat variabel prev_contact

Kode:

```r
prev_contact = as.integer(pdays != -1)
```

Output:

| prev_contact | Makna | Jumlah |
|---:|---|---:|
| 0 | Belum pernah dihubungi sebelumnya | 8.324 |
| 1 | Pernah dihubungi sebelumnya | 2.838 |

Interpretasi:

Nilai `pdays = -1` berarti nasabah belum pernah dihubungi pada kampanye sebelumnya. Variabel baru `prev_contact` dibuat agar informasi tersebut lebih sederhana.

### 11.5 Mengubah month menjadi angka

Kode:

```r
month = match(tolower(month),
              c("jan","feb","mar","apr","may","jun",
                "jul","aug","sep","oct","nov","dec"))
```

Output:

| Bulan | Kode | Jumlah |
|---|---:|---:|
| jan | 1 | 344 |
| feb | 2 | 776 |
| mar | 3 | 276 |
| apr | 4 | 923 |
| may | 5 | 2.824 |
| jun | 6 | 1.222 |
| jul | 7 | 1.514 |
| aug | 8 | 1.519 |
| sep | 9 | 319 |
| oct | 10 | 392 |
| nov | 11 | 943 |
| dec | 12 | 110 |

Interpretasi:

Nama bulan diubah menjadi angka 1 sampai 12 agar dapat digunakan dalam model.

### 11.6 Mengubah job, marital, contact, dan poutcome

Kode:

```r
job      = as.integer(factor(job))
marital  = as.integer(factor(marital))
contact  = as.integer(factor(contact))
poutcome = as.integer(factor(poutcome))
```

Output contoh pengkodean:

| Variabel | Contoh Kode |
|---|---|
| `job` | admin. = 1, blue-collar = 2, management = 5, student = 9 |
| `marital` | divorced = 1, married = 2, single = 3 |
| `contact` | cellular = 1, telephone = 2, unknown = 3 |
| `poutcome` | failure = 1, other = 2, success = 3, unknown = 4 |

Interpretasi:

Variabel kategori diubah menjadi kode angka. Angka ini hanya menjadi kode kategori, bukan urutan nilai. Contohnya, `student = 9` bukan berarti lebih tinggi daripada `admin. = 1`.

### 11.7 Menghapus pdays

Kode:

```r
select(-pdays)
```

Output:

Kolom `pdays` dihapus dari dataset `df_model`.

Interpretasi:

Kolom `pdays` dihapus karena informasinya sudah diringkas menjadi variabel baru `prev_contact`.

## 12. Struktur Data Setelah Preprocessing

Kode:

```r
cat("\nStruktur data setelah preprocessing:\n")
str(df_model)
```

### Fungsi kode

`str(df_model)` digunakan untuk melihat struktur dataset setelah preprocessing.

### Output utama

Setelah preprocessing:

| Keterangan | Hasil |
|---|---:|
| Jumlah baris | 11.162 |
| Jumlah kolom | 17 |
| Tipe data target | Integer 0 dan 1 |
| Kolom `pdays` | Dihapus |
| Kolom `prev_contact` | Ditambahkan |
| Data kategori | Sudah dikodekan menjadi numerik |

Contoh data setelah preprocessing:

| age | job | marital | education | default | balance | housing | loan | contact | day | month | duration | campaign | previous | poutcome | deposit | prev_contact |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 59 | 1 | 2 | 2 | 0 | 2343 | 1 | 0 | 3 | 5 | 5 | 1042 | 1 | 0 | 4 | 1 | 0 |
| 56 | 1 | 2 | 2 | 0 | 45 | 0 | 0 | 3 | 5 | 5 | 1467 | 1 | 0 | 4 | 1 | 0 |
| 41 | 10 | 2 | 2 | 0 | 1270 | 1 | 0 | 3 | 5 | 5 | 1389 | 1 | 0 | 4 | 1 | 0 |

## 13. Split Data Training dan Testing

Kode:

```r
set.seed(42)
idx        <- createDataPartition(df_model$deposit, p = 0.8, list = FALSE)
data_train <- df_model[idx, ]
data_test  <- df_model[-idx, ]

cat("\nData latih:", nrow(data_train), "| Data uji:", nrow(data_test), "\n")
```

### Fungsi kode

`set.seed(42)` digunakan agar hasil pembagian data tetap sama setiap kali script dijalankan.

`createDataPartition()` membagi data menjadi data latih dan data uji.

`p = 0.8` berarti 80% data digunakan sebagai data latih.

Sisa 20% digunakan sebagai data uji.

### Output

Output yang muncul di Console adalah jumlah data latih dan data uji. Nilainya sekitar:

| Data | Proporsi | Jumlah Perkiraan |
|---|---:|---:|
| Data latih | 80% | sekitar 8.930 data |
| Data uji | 20% | sekitar 2.232 data |

## 14. Model Regresi Logistik

Kode:

```r
model <- glm(deposit ~ ., data = data_train, family = binomial())
cat("\n=== RINGKASAN MODEL ===\n")
summary(model)
```

### Fungsi kode

`glm()` digunakan untuk membuat model Generalized Linear Model.

`deposit ~ .` berarti variabel `deposit` menjadi target, sedangkan seluruh variabel lain digunakan sebagai prediktor.

`family = binomial()` menunjukkan bahwa model yang digunakan adalah regresi logistik biner.

### Output

Output `summary(model)` menampilkan:

1. Estimate
2. Standard error
3. z value
4. p value
5. Signifikansi setiap variabel

### Interpretasi output

Variabel dengan p value kecil menunjukkan bahwa variabel tersebut memiliki pengaruh yang signifikan terhadap peluang nasabah melakukan deposit.

Nilai estimate positif berarti variabel tersebut meningkatkan peluang deposit.

Nilai estimate negatif berarti variabel tersebut menurunkan peluang deposit.

## 15. Odds Ratio

Kode:

```r
cat("\n--- Odds Ratio ---\n")
print(round(exp(cbind(OR = coef(model),
                      suppressMessages(confint(model)))), 3))
```

### Fungsi kode

`coef(model)` mengambil koefisien dari model.

`exp()` mengubah koefisien logit menjadi odds ratio.

`confint(model)` menghitung confidence interval.

`round(..., 3)` membulatkan hasil menjadi tiga angka desimal.

### Interpretasi odds ratio

Jika odds ratio lebih dari 1, variabel tersebut meningkatkan peluang deposit.

Jika odds ratio kurang dari 1, variabel tersebut menurunkan peluang deposit.

Jika odds ratio mendekati 1, pengaruhnya kecil.

## 16. Prediksi dan Evaluasi

Kode:

```r
prob  <- predict(model, newdata = data_test, type = "response")
pred  <- factor(ifelse(prob >= 0.5, 1, 0), levels = c(0,1))
aktual <- factor(data_test$deposit, levels = c(0,1))
```

### Fungsi kode

`predict()` menghasilkan probabilitas nasabah melakukan deposit.

`type = "response"` membuat output prediksi berbentuk probabilitas antara 0 dan 1.

`ifelse(prob >= 0.5, 1, 0)` mengubah probabilitas menjadi kelas prediksi.

Jika probabilitas minimal 0,5, maka prediksi menjadi 1.

Jika probabilitas kurang dari 0,5, maka prediksi menjadi 0.

## 17. Confusion Matrix

Kode:

```r
cm <- confusionMatrix(pred, aktual, positive = "1")
cat("\n=== CONFUSION MATRIX ===\n")
print(cm)
```

### Fungsi kode

`confusionMatrix()` digunakan untuk membandingkan hasil prediksi model dengan data aktual.

`positive = "1"` berarti kelas positif adalah nasabah yang melakukan deposit.

### Output

Output confusion matrix menampilkan:

| Komponen | Makna |
|---|---|
| True Positive | Nasabah deposit dan diprediksi deposit |
| True Negative | Nasabah tidak deposit dan diprediksi tidak deposit |
| False Positive | Nasabah tidak deposit tetapi diprediksi deposit |
| False Negative | Nasabah deposit tetapi diprediksi tidak deposit |

### Interpretasi output

Confusion matrix menunjukkan seberapa baik model membedakan nasabah yang melakukan deposit dan tidak melakukan deposit.

## 18. Plot Confusion Matrix

Kode:

```r
as.data.frame(cm$table) %>%
  ggplot(aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 8, fontface = "bold", color = "white") +
  scale_fill_gradient(low = "#90CAF9", high = "#1565C0") +
  labs(title = "Gambar 6. Confusion Matrix – Regresi Logistik",
       x = "Aktual", y = "Prediksi") +
  theme_minimal(base_size = 13) + theme(legend.position = "none")
```

### Fungsi kode

Kode ini mengubah confusion matrix menjadi dataframe lalu menampilkannya dalam bentuk heatmap.

`geom_tile()` membuat kotak confusion matrix.

`geom_text()` menampilkan angka di dalam kotak.

`scale_fill_gradient()` memberi gradasi warna sesuai jumlah frekuensi.

### Output

Output berupa visualisasi confusion matrix.

### Interpretasi output

Kotak dengan angka besar menunjukkan jumlah prediksi pada kategori tersebut. Jika nilai True Positive dan True Negative tinggi, maka model bekerja dengan baik.

## 19. ROC Curve dan AUC

Kode:

```r
roc_obj <- roc(data_test$deposit, prob, quiet = TRUE)
plot(roc_obj, col = "#1565C0", lwd = 2.5,
     main = "Gambar 7. ROC Curve – Regresi Logistik")
abline(a = 0, b = 1, lty = 2, col = "gray")
legend("bottomright",
       legend = sprintf("AUC = %.3f", auc(roc_obj)),
       col = "#1565C0", lwd = 2, bty = "n")
```

### Fungsi kode

`roc()` membuat objek ROC Curve.

`plot()` menampilkan ROC Curve.

`abline()` menambahkan garis pembanding diagonal.

`auc()` menghitung nilai AUC.

### Output

Output berupa grafik ROC Curve dan nilai AUC.

### Interpretasi output

ROC Curve menunjukkan kemampuan model membedakan kelas 0 dan 1.

AUC mendekati 1 berarti model sangat baik.

AUC mendekati 0,5 berarti model tidak lebih baik dari tebakan acak.

## 20. Ringkasan Metrik Evaluasi

Kode:

```r
cat("\n╔══════════════════════════╗\n")
cat("║    HASIL EVALUASI MODEL  ║\n")
cat("╠══════════════════════════╣\n")
cat(sprintf("║ Akurasi  : %6.2f%%       ║\n", cm$overall["Accuracy"]*100))
cat(sprintf("║ Presisi  : %6.2f%%       ║\n", cm$byClass["Precision"]*100))
cat(sprintf("║ Recall   : %6.2f%%       ║\n", cm$byClass["Recall"]*100))
cat(sprintf("║ F1-Score : %6.2f%%       ║\n", cm$byClass["F1"]*100))
cat(sprintf("║ AUC      : %6.3f         ║\n", auc(roc_obj)))
cat("╚══════════════════════════╝\n")
```

### Fungsi kode

Kode ini menampilkan ringkasan hasil evaluasi model dalam bentuk tabel teks di Console.

| Metrik | Penjelasan |
|---|---|
| Akurasi | Persentase prediksi benar dari seluruh data uji |
| Presisi | Ketepatan model saat memprediksi deposit |
| Recall | Kemampuan model menemukan nasabah yang benar-benar deposit |
| F1-Score | Gabungan presisi dan recall |
| AUC | Kemampuan model membedakan kelas deposit dan tidak deposit |

### Interpretasi output

Semakin tinggi nilai akurasi, presisi, recall, F1-Score, dan AUC, maka performa model semakin baik.

## 21. Kesimpulan

Kode ini menjalankan proses klasifikasi nasabah bank secara lengkap, mulai dari membaca dataset sampai mengevaluasi model.

Dataset memiliki 11.162 data dan 17 variabel, tanpa missing value.

Hasil EDA menunjukkan beberapa pola penting:

1. Nasabah yang melakukan deposit memiliki saldo lebih tinggi.
2. Nasabah yang melakukan deposit memiliki durasi panggilan lebih lama.
3. Pekerjaan seperti `student` dan `retired` memiliki proporsi deposit lebih tinggi.

Preprocessing mengubah variabel teks menjadi angka agar dapat digunakan oleh model regresi logistik.

Model regresi logistik kemudian digunakan untuk memprediksi keputusan deposit. Hasil evaluasi ditampilkan melalui confusion matrix, ROC Curve, AUC, akurasi, presisi, recall, dan F1-Score.

## 22. Catatan Pengembangan

Kode ini sudah dapat digunakan untuk analisis dasar dan klasifikasi dengan regresi logistik. Namun, untuk pengembangan lebih lanjut, beberapa hal dapat dilakukan:

1. Menggunakan one-hot encoding untuk variabel kategori seperti `job`, `marital`, `contact`, dan `poutcome`.
2. Membandingkan regresi logistik dengan model lain seperti Decision Tree, Random Forest, atau XGBoost.
3. Melakukan feature selection untuk memilih variabel yang paling berpengaruh.
4. Menguji model tanpa variabel `duration` jika prediksi ingin dilakukan sebelum panggilan selesai.
5. Menambahkan validasi silang atau cross validation agar evaluasi model lebih stabil.
