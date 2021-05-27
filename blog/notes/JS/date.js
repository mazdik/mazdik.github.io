/* Date 2019-04-05 */
new Date().toISOString().slice(0, 10);
// date 1 hour ago
new Date(Date.now() + -1*3600*1000).toISOString();
// date 5 days ago
new Date(Date.now() + -5*24*3600*1000).toISOString();
// add months
var d = new Date();
d.setMonth(d.getMonth() + 1);
/* Получать timestamp из даты и времен */
console.log(+new Date()); // Количество миллисекунд
console.log(Math.floor(new Date() / 1000)); // Количество секунд
// Date
var date = new Date();
// Add a day
var endDate = new Date(date.setDate(date.getDate() + 1));
// Add a day
// seconds * minutes * hours * milliseconds = 1 day 
var endDate = new Date(date.getTime() + (60 * 60 * 24 * 1000));
// Add month
var endDate = new Date(date.getFullYear(), date.getMonth() + 1, 1);
// Add month
var endDate  =  new Date(date.setMonth(date.getMonth() + 8));
// toISOString() ignores timezone offset
var date = new Date(); // Or the date you'd like converted.
isoDate = new Date(date.getTime() - (date.getTimezoneOffset() * 60000)).toISOString();


// Парсер даты DD.MM.YYYY HH:mm:ss
function parseDate(strDate: string, showTime: boolean, showSeconds: boolean): Date {
    const patDate = /^(\d{2}).(\d{2}).(\d{4})$/; // DD.MM.YYYY
    const patDateTime = /^(\d{2}).(\d{2}).(\d{4})\s(\d{1,2}):(\d{2})$/; // DD.MM.YYYY HH:mm
    const patDateTimeSec = /^(\d{2}).(\d{2}).(\d{4})\s(\d{1,2}):(\d{2}):(\d{2})$/; // DD.MM.YYYY HH:mm:ss
  
    let pattern = showTime ? (showSeconds ? patDateTimeSec : patDateTime) : patDate;
    const [, day, month, year, hour = 0, min = '00', sec = '00'] = pattern.exec(strDate);
    const iso = `${year}-${month}-${day}T${('0' + hour).slice(-2)}:${min}:${sec}`;
    return new Date(iso);
}
  
function isValidDate(date) {
  return date instanceof Date && !isNaN(date.getTime());
}
