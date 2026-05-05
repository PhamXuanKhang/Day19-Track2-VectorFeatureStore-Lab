# Reflection — Lab 19

**Tên:** Phạm Xuân Khang
**Cohort:** A20-K1
**Path đã chạy:** lite

---

## Câu hỏi (≤ 200 chữ)

> Trên golden set 50 queries, mode nào thắng ở loại query nào (`exact` /
> `paraphrase` / `mixed`), và tại sao? Khi nào bạn **không** dùng hybrid
> (i.e. khi nào pure BM25 hoặc pure vector là lựa chọn đúng)?

Trên golden set 50 queries, **hybrid (RRF k=60) thắng trung bình** với Precision@10 = 78.6%, so với BM25 (77.8%) và vector (73.2%).

Phân tích theo loại query:
- **exact**: BM25 thắng rõ (96.7%) và hybrid ngang bằng (96.7%), vì query chứa từ khóa kỹ thuật verbatim — BM25 match chính xác, hybrid giữ được signal này qua RRF.
- **paraphrase**: BM25 vẫn dẫn (33.3%) dù lẽ ra vector nên thắng. Nguyên nhân: model `bge-small-en-v1.5` được train trên tiếng Anh nên hiểu semantic tiếng Việt kém. Đổi sang multilingual model (vd: `bge-m3`) sẽ cải thiện đáng kể.
- **mixed**: Hybrid thắng tuyệt đối (100.0% vs 98.5% semantic vs 97.0% BM25), vì query vừa có exact term vừa có paraphrase — RRF kết hợp tốt nhất signal từ cả hai retriever.

**Khi nào KHÔNG dùng hybrid?** Khi query luôn là exact keyword (BM25 đủ tốt và nhanh hơn ~10x về latency: P99 BM25 = 71.8ms vs hybrid = 161.4ms). Hoặc khi hệ thống yêu cầu latency cực thấp mà không chấp nhận overhead chạy hai retriever song song.

---

## Điều ngạc nhiên nhất khi làm lab này

_(Optional, 1–2 câu)_

---

## Bonus challenge

- [ ] Đã làm bonus (xem `bonus/`)
- [ ] Pair work với: _<tên đồng đội nếu có>_
