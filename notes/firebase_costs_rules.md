1. No realtime listeners unless realtime is genuinely required.

2. Prefer get() over snapshots() for discovery.

3. Paginate tutor results.
   → Never download the entire tutor collection.

4. Query only the fields/data needed for the screen.

5. Cache stable data locally where useful.

6. Don't repeatedly fetch the same tutor profile.

7. Keep documents small.

8. Derived aggregates such as rating/reliability are precomputed.

9. Use Cloud Functions/backend for expensive or privileged operations.

10. Batch writes whenever possible.

11. Avoid polling.

12. Avoid N+1 reads.
