<?php

public function actions() 
{ 
    $actions = parent::actions();
    $actions['index']['prepareDataProvider'] = [$this, 'prepareDataProvider'];
    return $actions;
}

public function prepareDataProvider() 
{
    $searchModel = new \app\models\ProductSearch();    
    return $searchModel->search(\Yii::$app->request->queryParams);
}

// Then be sure that your search class is using load($params,'') instead of load($params) or alternatively add this to the model class:

class Product extends \yii\db\ActiveRecord
{
    public function formName()
    {
        return '';
    }

/*
That should be enough to have your requests looking like:

/products?name=iphone&status=available&sort=name,-price
