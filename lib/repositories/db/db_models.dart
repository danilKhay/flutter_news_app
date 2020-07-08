import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'db_models.g.dart';

const tableBookmark = SqfEntityTable(
  tableName: 'bookmark',
  useSoftDeleting: true,
  primaryKeyName: "id",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  modelName: null,
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('imageUrl', DbType.text),
    SqfEntityField('sourceName', DbType.text),
    SqfEntityField('sourceImageUrl', DbType.text),
    SqfEntityField('content', DbType.text),
    SqfEntityField('dateTime', DbType.datetime),
  ],
);

const tableCache = SqfEntityTable(
  tableName: 'cache',
  primaryKeyName: "id",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  modelName: null,
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('imageUrl', DbType.text),
    SqfEntityField('sourceName', DbType.text),
    SqfEntityField('sourceImageUrl', DbType.text),
    SqfEntityField('content', DbType.text),
    SqfEntityField('dateTime', DbType.datetime),
  ],
);

@SqfEntityBuilder(dbModel)
const dbModel = SqfEntityModel(
  modelName: 'DbModel',
  databaseName: 'newsDb.db',
  databaseTables: [tableBookmark, tableCache],
);