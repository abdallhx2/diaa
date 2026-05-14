import asyncio
from app.database import SessionLocal
from app.models.lesson import Lesson
from app.services.chat_service import summarize


async def main():
    db = SessionLocal()
    lessons = db.query(Lesson).filter((Lesson.summary == None) | (Lesson.summary == "")).all()
    print(f"Found {len(lessons)} lessons needing summary")
    for i, l in enumerate(lessons, 1):
        try:
            s = await summarize(l.original_text)
            l.summary = s
            db.commit()
            print(f"[{i}/{len(lessons)}] {l.title[:30]} -> {len(s)} chars")
        except Exception as e:
            db.rollback()
            print(f"[{i}/{len(lessons)}] {l.title[:30]} FAILED: {e}")
    db.close()


if __name__ == "__main__":
    asyncio.run(main())
