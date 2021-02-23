// Fetch: POST json data
let token = null;
fetch('http://localhost:5000/api/user/login', {
  method: 'post',
  headers: {
    'Accept': 'application/json, text/plain, */*',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({username: 'user1', password: 'test'})
}).then(res=>res.json())
  .then(res => { console.log(res); token = res.token});

//  Fetch: GET json data
fetch('http://localhost:5000/api/user/test', {
  method: 'get',
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  }
}).then(res=>res.json())
  .then(res => console.log(res));
