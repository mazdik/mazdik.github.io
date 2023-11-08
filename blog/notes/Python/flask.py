# Flask request
search = request.args.get("search") # get
email = request.form.get('email') # post form
request.json # post json

# Flask Restless
?q={"filters":[{"name":"sk","op":"eq","val":1010000222}]}
?q={"order_by":[{"field":"dz","direction":"desc"}],"limit":2}
?q={"filters":[{"name":"sk","op":"eq","val":1010000222}],"order_by":[{"field":"dz","direction":"desc"}],"limit":2}

# datetime JSON serializable
from datetime import date, datetime

def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError("Type %s not serializable" % type(obj))
