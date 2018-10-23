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

@interface ResultColumnTests : WINQTestCase

@end

@implementation ResultColumnTests {
    WCDB::Expression expression;
    NSString* alias;
    NSString* table;
}

- (void)setUp
{
    [super setUp];
    expression = 1;
    alias = @"testAlias";
    table = @"testTable";
}

- (void)test_default_constructible
{
    WCDB::ResultColumn constructible __attribute((unused));
}

- (void)test_result_column
{
    auto testingSQL = WCDB::ResultColumn(expression);

    auto testingTypes = { WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"1");
}

- (void)test_result_column_with_alias
{
    auto testingSQL = WCDB::ResultColumn(expression).as(alias);

    auto testingTypes = { WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"1 AS testAlias");
}

- (void)test_all
{
    auto testingSQL = WCDB::ResultColumnAll();

    auto testingTypes = { WCDB::SQL::Type::ResultColumn };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"*");
}

- (void)test_all_with_table
{
    auto testingSQL = WCDB::ResultColumnAll().inTable(table);

    auto testingTypes = { WCDB::SQL::Type::ResultColumn };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testTable.*");
}

WCDB::ResultColumn acceptable(const WCDB::ResultColumn& resultColumn)
{
    return resultColumn;
}

- (void)test_convertible
{
    WINQAssertEqual(acceptable(1), @"1");
    WINQAssertEqual(acceptable(@(1)), @"1");
    WINQAssertEqual(acceptable(true), @"1");
    WINQAssertEqual(acceptable(YES), @"1");
    WINQAssertEqual(acceptable(WCDB::Column("testColumn")), @"testColumn");
    WINQAssertEqual(acceptable((float) 0.1), @"0.1");
    WINQAssertEqual(acceptable((double) 0.1), @"0.1");
    WINQAssertEqual(acceptable("test"), @"'test'");
    WINQAssertEqual(acceptable(@"test"), @"'test'");
    WINQAssertEqual(acceptable(std::string("test")), @"'test'");
    WINQAssertEqual(acceptable(nullptr), @"NULL");
    WINQAssertEqual(acceptable(nil), @"NULL");
    WINQAssertEqual(acceptable(WCDB::LiteralValue::currentTime()), @"CURRENT_TIME");
    WINQAssertEqual(acceptable(WCDB::Expression(1)), @"1");
}

@end