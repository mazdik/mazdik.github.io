// Sock Merchant
// [10, 20, 20, 10, 10, 30, 50, 10, 20] -> 3
// JS
function sockMerchant(n, ar) {
    const counts = {};
    ar.forEach(x => {
        counts[x] = counts[x] ? counts[x] + 1 : 1;
    });
    let result = 0;
    for (var key in counts) {
        result += Math.floor(counts[key] / 2);
    }
    return result;
}
// C#
public static int sockMerchant(int n, int[] ar)
{
    return ar.GroupBy(x => x).Select(g => new { g.Key, Cnt = (int)Math.Floor((decimal)g.Count() / 2) }).Sum(x => x.Cnt);
}
// SQL
select sum(cnt) from (select x, floor(count(*) / 2) as cnt from w group by x)
// Python
def sockMerchant(n, ar):
    return sum(({i:int(ar.count(i)/2) for i in ar}).values())

// Time Conversion
// 07:05:45PM -> 19:05:45
function timeConversion(time12h) {
    const modifier = time12h.substring(8, 10);
    let [hours, minutes, seconds] = time12h.substring(0, 8).split(':');
    if (hours === '12') {
        hours = '00';
    }
    if (modifier === 'PM') {
        hours = parseInt(hours, 10) + 12;
    }
    return hours + ':' + minutes + ':' + seconds;;
}

// Grading Students
// [73, 67, 38, 33] -> [75, 67, 40, 33]
function gradingStudents(grades) {
    return grades.map(x => {
        const next = 5 * (Math.ceil(Math.abs(x / 5)));
        return (x >= 38 && (next - x) < 3) ? next : x;
    });
}

// Strong Password
// Ab1 -> 3 | #HackerRank -> 1 | 9 -> 5
function minimumNumber(n, password) {
    const numbers = "0123456789";
    const lower_case = "abcdefghijklmnopqrstuvwxyz";
    const upper_case = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const special_characters = "!@#$%^&*()-+";
    let result = 0;
    password = password.toString();
    password = [...password];
    result = (password.some(r => numbers.includes(r))) ? result + 1 : result;
    result = (password.some(r => lower_case.includes(r))) ? result + 1 : result;
    result = (password.some(r => upper_case.includes(r))) ? result + 1 : result;
    result = (password.some(r => special_characters.includes(r))) ? result + 1 : result;
    result = 4 - result;
    if (password.length < 6) {
        result = Math.max((6 - password.length), result);
    }
    return result;
}

// Pangrams
let res = [...new Set([...s.toString().toLowerCase()])].filter(x => /[a-z]/.test(x));
(res.length === 26) ? 'pangram' : 'not pangram';
