export interface TutorDayBounds {
  start: Date;
  end: Date;
}

function getTimeZoneOffsetMinutes(
  date: Date,
  timeZone: string,
): number {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone,
    timeZoneName: "longOffset",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hourCycle: "h23",
  }).formatToParts(date);

  const timeZoneName = parts.find(
    (part) => part.type === "timeZoneName",
  )?.value;

  if (!timeZoneName) {
    throw new Error(
      `Unable to determine timezone offset for ${timeZone}.`,
    );
  }

  if (timeZoneName === "GMT") {
    return 0;
  }

  const match = timeZoneName.match(
    /^GMT([+-])(\d{2}):(\d{2})$/,
  );

  if (!match) {
    throw new Error(
      `Unable to parse timezone offset: ${timeZoneName}.`,
    );
  }

  const sign = match[1] === "+" ? 1 : -1;
  const hours = Number(match[2]);
  const minutes = Number(match[3]);

  return sign * (hours * 60 + minutes);
}

function localMidnightToUtc(
  year: number,
  month: number,
  day: number,
  timeZone: string,
): Date {
  const localMidnightAsUtc =
    Date.UTC(year, month - 1, day, 0, 0, 0, 0);

  let utcTimestamp = localMidnightAsUtc;

  for (let i = 0; i < 3; i++) {
    const offsetMinutes =
      getTimeZoneOffsetMinutes(
        new Date(utcTimestamp),
        timeZone,
      );

    utcTimestamp =
      localMidnightAsUtc -
      offsetMinutes * 60 * 1000;
  }

  return new Date(utcTimestamp);
}

export function getTutorDayBounds(
  date: Date,
  timeZone: string,
): TutorDayBounds {
  const parts = new Intl.DateTimeFormat(
    "en-US",
    {
      timeZone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    },
  ).formatToParts(date);

  const values = Object.fromEntries(
    parts.filter(
      (part) =>
        part.type === "year" ||
        part.type === "month" ||
        part.type === "day",
    )
    .map((part) => [
      part.type,
      Number(part.value),
    ]),
  );

  const year = values.year;
  const month = values.month;
  const day = values.day;

  const start = localMidnightToUtc(
    year,
    month,
    day,
    timeZone,
  );

  const nextDay = new Date(
    Date.UTC(year, month - 1, day + 1),
  );

  const end = localMidnightToUtc(
    nextDay.getUTCFullYear(),
    nextDay.getUTCMonth() + 1,
    nextDay.getUTCDate(),
    timeZone,
  );

  return {
    start,
    end,
  };
}
