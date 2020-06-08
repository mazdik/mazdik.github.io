""" CRUD with SQLAlchemy
in controller:
dept = Blueprint('dept', __name__)

@dept.route('/dept', methods=['POST', 'PUT', 'DELETE'])
def post():
    result = post_put_delete(Dept)
    return jsonify(result)

in model:
class Dept(db.Model)
"""
from sqlalchemy.inspection import inspect
from db import db
from flask import request
from datetime import datetime
from dateutil import parser


def to_date(key, value):
    if isinstance(value, datetime) or value is None:
        return value
    if str.lower(key).find('date') != -1 and isinstance(value, str):
        return parser.parse(value)
    else:
        return value


def extract_primary_keys(subject, **kwargs):
    keys_columns = [key.name for key in inspect(subject).primary_key]
    keys = {}
    for key, value in kwargs.items():
        if key in keys_columns:
            keys[key] = to_date(key, value)
    return keys


def object_as_dict(obj):
    return {c.key: getattr(obj, c.key)
            for c in inspect(obj).mapper.column_attrs}


def remove_extra_keys(subject, **kwargs):
    mapper = inspect(subject)
    columns = [column.key for column in mapper.attrs]
    for key, value in kwargs.copy().items():
        if key not in columns:
            kwargs.pop(key, None)
        kwargs[key] = to_date(key, value)
    return kwargs


def upsert(subject, **kwargs):
    keys = extract_primary_keys(subject, **kwargs)
    kwargs = remove_extra_keys(subject, **kwargs)
    if keys:
        wl = subject.query.filter_by(**keys).first()
    else:
        wl = None
    try:
        if wl is None:
            wl = subject(**kwargs)
            db.session.add(wl)
        else:
            for key, value in kwargs.items():
                setattr(wl, key, value)
        set_update_date(wl)

        db.session.commit()
    except Exception:
        db.session.rollback()
        raise
    return object_as_dict(wl)


def delete(subject, **kwargs):
    keys = extract_primary_keys(subject, **kwargs)
    wl = subject.query.filter_by(**keys).first()
    try:
        db.session.delete(wl)
        db.session.commit()
    except Exception:
        db.session.rollback()
        raise
    return {'result': True}


def post_put_delete(subject):
    args = request.args.to_dict()
    res = {}
    if request.method in ('POST', 'PUT'):
        if 'process' in request.json:
            res = delete(subject, **request.json['row'])
        else:
            res = upsert(subject, **request.json)
    if request.method == 'DELETE':
        res = delete(subject, **args)
    return res


def set_update_date(instance):
    if hasattr(instance, 'date_change'):
        setattr(instance, 'date_change', datetime.now())
    return instance
