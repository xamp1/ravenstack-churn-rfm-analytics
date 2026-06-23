# ravenstack-churn-rfm-analytics

Analisis ini dibuat untuk mencari penyebab tingginya churn pada platform SaaS **RavenStack** dan mengidentifikasi pelanggan yang berpotensi churn menggunakan segmentasi **RFM (Recency, Frequency, Monetary)**.

Dataset diproses menggunakan **Google BigQuery**, kemudian hasil analisis divisualisasikan dalam dashboard berbasis **Tailwind CSS**.

## Business Case

RavenStack memiliki churn rate sekitar **22%** pada seluruh paket (Basic, Pro, dan Enterprise). Angka tersebut cukup tinggi, terutama pada pelanggan Enterprise yang seharusnya memiliki tingkat retensi lebih baik.

## Key Findings

### Enterprise

* Rata-rata waktu penyelesaian tiket paling lama (**15.2 jam**).
* Memiliki CSAT terendah (**2.0/5.0**).
* Hampir tidak ditemukan error pada log penggunaan, yang mengindikasikan kemungkinan terjadinya **silent churn**.

### Basic

* Memiliki error rate tertinggi (**15.31%**).
* Sebagian besar pengguna berhenti menggunakan layanan tanpa banyak membuat support ticket.

### RFM Segmentation

Dari **390 akun aktif**, distribusi segmen pelanggan adalah:

| Segment                     | Accounts |
| --------------------------- | -------: |
| Hibernating / At Risk       |      138 |
| Loyal Customers             |       96 |
| Can't Lose Them             |       58 |
| Low Spender / Highly Active |       58 |
| Champions                   |       40 |

Segmen **Can't Lose Them** menjadi prioritas karena memiliki nilai bisnis tinggi tetapi aktivitasnya mulai menurun.

## Tech Stack

* Google BigQuery
* SQL (CTE, JOIN, NTILE)
* Tailwind CSS
* HTML & JavaScript

## SQL Highlights

Beberapa analisis utama yang digunakan dalam proyek ini:

* Churn analysis berdasarkan plan
* Error rate vs churn
* Support performance (SLA & CSAT)
* RFM segmentation menggunakan `NTILE()`
* Perilaku pelanggan berdasarkan aktivitas penggunaan dan support ticket

## Notes

Salah satu tantangan pada dataset adalah tabel `feature_usage` tidak memiliki `account_id` secara langsung. Relasi dilakukan melalui tabel `subscriptions` menggunakan `subscription_id` sebelum digabungkan dengan tabel `accounts`.
