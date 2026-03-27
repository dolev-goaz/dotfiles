const weekDays = [
  { day: "Sun", today: 0 },
  { day: "Mon", today: 0 },
  { day: "Tue", today: 0 },
  { day: "Wed", today: 0 },
  { day: "Thu", today: 0 },
  { day: "Fri", today: 0 },
  { day: "Sat", today: 0 },
];

/**
 * @param {number} year - The year to check.
 * @return {boolean} - Returns true if the year is a leap year, false otherwise.
 **/
function isLeapYear(year) {
  return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
}

/**
 * @param {number} month - The month (1-12).
 * @param {number} year - The year.
 * @return {number} - The number of days in the month.
 **/
function getMonthDays(month, year) {
  if ((month <= 7 && month % 2 == 1) || (month >= 8 && month % 2 == 0))
    return 31;
  if (month != 2) return 30;
  return isLeapYear(year) ? 29 : 28;
}

/**
 * @param {number} month - The month (1-12).
 * @param {number} year - The year.
 * @return {number} - The number of days in the next month.
 **/
function getNextMonthDays(month, year) {
  const nextMonth = month == 12 ? 1 : month + 1;
  if (nextMonth == 1) {
    return 31; // January
  }
  // same year
  return getMonthDays(nextMonth, year);
}

/**
 * @param {number} month - The month (1-12).
 * @param {number} year - The year.
 * @return {number} - The number of days in the previous month.
 **/
function getPrevMonthDays(month, year) {
  const prevMonth = month == 1 ? 12 : month - 1;
  if (prevMonth == 12) {
    return 31; // December
  }
  // same year
  return getMonthDays(prevMonth, year);
}

/**
 * @param {number} x - The number of months to add (can be negative).
 * @return {Date} - The date in x months time.
 **/
function getDateInXMonthsTime(x) {
  const currentDate = new Date(); // Get the current date
  if (x == 0) return currentDate; // If x is 0, return the current date

  var targetMonth = currentDate.getMonth() + x; // Calculate the target month
  var targetYear = currentDate.getFullYear(); // Get the current year

  // Adjust the year and month if necessary
  targetYear += Math.floor(targetMonth / 12);
  targetMonth = ((targetMonth % 12) + 12) % 12;

  return new Date(targetYear, targetMonth, 1);
}

/**
 * @param {Date} dateObject - The date object to get the calendar layout for.
 * @param {boolean} highlight - Whether to highlight today's date.
 * @return {Array} - A 2D array representing the calendar layout (only rows needed).
 **/
function getCalendarLayout(dateObject, highlight) {
  if (!dateObject) dateObject = new Date();

  const today = new Date();
  const month = dateObject.getMonth() + 1;
  const year = dateObject.getFullYear();

  // Get weekday of the first day of the month (0=Sunday, 1=Monday, ...)
  const firstDayOfMonth = new Date(year, month - 1, 1).getDay();

  const daysInMonth = getMonthDays(month, year);
  const daysInPrevMonth = getPrevMonthDays(month, year);

  // Start from the last few days of previous month if first day isn't Sunday
  let startDay =
    firstDayOfMonth === 0 ? 1 : daysInPrevMonth - firstDayOfMonth + 1;
  let currentMonth = firstDayOfMonth === 0 ? 0 : -1; // 0: current, -1: previous, 1: next
  let daysInCurrent = firstDayOfMonth === 0 ? daysInMonth : daysInPrevMonth;

  const calendar = Array.from({ length: 6 }, () => Array(7));

  for (let week = 0; week < 6; week++) {
    for (let weekday = 0; weekday < 7; weekday++) {
      calendar[week][weekday] = {
        day: startDay,
        today:
          highlight &&
          currentMonth === 0 &&
          startDay === today.getDate() &&
          month === today.getMonth() + 1 &&
          year === today.getFullYear()
            ? 1
            : currentMonth === 0
              ? 0
              : -1,
      };
      startDay++;
      if (startDay > daysInCurrent) {
        if (currentMonth === -1) {
          // Switch to current month
          startDay = 1;
          daysInCurrent = daysInMonth;
          currentMonth = 0;
        } else if (currentMonth === 0) {
          // Switch to next month
          startDay = 1;
          daysInCurrent = getNextMonthDays(month, year);
          currentMonth = 1;
        }
      }
    }
  }

  // Trim trailing rows that contain only next-month days
  let numRows = 6;
  while (numRows > 1 && calendar[numRows - 1].every(cell => cell.today === -1)) {
    numRows--;
  }

  return calendar.slice(0, numRows);
}
