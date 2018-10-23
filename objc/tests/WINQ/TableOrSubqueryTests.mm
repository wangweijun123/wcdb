/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "WINQTestCase.h"
#import <WCDB/WCDB.h>

@interface TableOrSubqueryTests : WINQTestCase

@end

@implementation TableOrSubqueryTests {
    WCDB::Schema schema;
    NSString* table;
    NSString* alias;
    NSString* index;
    NSString* function;
    WCDB::Expressions expressions;
    WCDB::TablesOrSubqueries tablesOrSubqueries;
    WCDB::Join join;
    WCDB::StatementSelect select;
}

- (void)setUp
{
    [super setUp];
    schema = @"testSchema";
    table = @"testTable";
    alias = @"testAliasTable";
    index = @"testIndex";
    function = @"testFunction";
    expressions = {
        1,
        2,
    };
    tablesOrSubqueries = {
        @"testTable1",
        @"testTable2",
    };
    join = WCDB::Join().table(@"testJoinTable");
    select = WCDB::StatementSelect().select(1);
}

- (void)test_default_constructible
{
    WCDB::TableOrSubquery constructible __attribute((unused));
}

- (void)test_table
{
    auto testingSQL = WCDB::TableOrSubquery(table);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testTable");
}

- (void)test_table_with_schema
{
    auto testingSQL = WCDB::TableOrSubquery(table).schema(schema);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testSchema.testTable");
}

- (void)test_table_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery(table).as(alias);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testTable AS testAliasTable");
}

- (void)test_table_with_index
{
    auto testingSQL = WCDB::TableOrSubquery(table).indexed(index);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testTable INDEXED BY testIndex");
}

- (void)test_table_without_index
{
    auto testingSQL = WCDB::TableOrSubquery(table).notIndexed();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testTable NOT INDEXED");
}

- (void)test_table_function
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testFunction()");
}

- (void)test_table_function_with_schema
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).schema(schema).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testSchema.testFunction()");
}

- (void)test_table_function_with_parameters
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).invoke(expressions);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testFunction(1, 2)");
}

- (void)test_table_function_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery::function(function).as(alias).invoke();

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testFunction() AS testAliasTable");
}

- (void)test_tables_or_subqueries
{
    auto testingSQL = WCDB::TableOrSubquery(tablesOrSubqueries);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema, WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"(main.testTable1, main.testTable2)");
}

- (void)test_join
{
    auto testingSQL = WCDB::TableOrSubquery(join);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::JoinClause, WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::Schema };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"(main.testJoinTable)");
}

- (void)test_select
{
    auto testingSQL = WCDB::TableOrSubquery(select);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"(SELECT 1)");
}

- (void)test_select_with_alias
{
    auto testingSQL = WCDB::TableOrSubquery(select).as(alias);

    auto testingTypes = { WCDB::SQL::Type::TableOrSubquery, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"(SELECT 1) AS testAliasTable");
}

WCDB::TableOrSubquery acceptable(const WCDB::TableOrSubquery& tableOrSubquery)
{
    return tableOrSubquery;
}

- (void)test_convertible
{
    WINQAssertEqual(acceptable("testTable"), @"main.testTable");
    WINQAssertEqual(acceptable(@"testTable"), @"main.testTable");
    WINQAssertEqual(acceptable(std::string("testTable")), @"main.testTable");
    WINQAssertEqual(acceptable(WCDB::Join().table(@"testTable")), @"(main.testTable)");
    WINQAssertEqual(acceptable(WCDB::TablesOrSubqueries({ @"testTable1", @"testTable2" })), @"(main.testTable1, main.testTable2)");
    WINQAssertEqual(acceptable(WCDB::StatementSelect().select(1)), @"(SELECT 1)");
}

@end