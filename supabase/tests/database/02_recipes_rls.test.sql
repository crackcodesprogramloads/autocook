BEGIN;

-- Start declare we'll have 4 test cases in our test suite
SELECT plan(4);

-- Setup our testing data
-- Set up auth.users entries
INSERT INTO auth.users (id) VALUES
    ('00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000002');

-- Create test recipes with valid UUIDs and JSONB arrays
-- We'll explicitly cast the UUIDs and arrays to ensure no ambiguity
INSERT INTO public.recipes (id, user_id, title, ingredients, instructions) VALUES
    ('11111111-1111-1111-1111-111111111111'::uuid, '00000000-0000-0000-0000-000000000001', 'Pancakes', ARRAY['"Flour"', '"Eggs"']::jsonb[], ARRAY['"Mix"', '"Cook"']::jsonb[]),
    ('22222222-2222-2222-2222-222222222222'::uuid, '00000000-0000-0000-0000-000000000001', 'Salad', ARRAY['"Lettuce"', '"Tomato"']::jsonb[], ARRAY['"Chop"', '"Toss"']::jsonb[]),
    ('33333333-3333-3333-3333-333333333333'::uuid, '00000000-0000-0000-0000-000000000002', 'Soup', ARRAY['"Broth"', '"Carrots"']::jsonb[], ARRAY['"Boil"', '"Serve"']::jsonb[]);

-- as User 1
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claim.sub = '00000000-0000-0000-0000-000000000001';

-- Test 1: User 1 should only see their own recipes
SELECT results_eq(
    'select count(*) from recipes',
    ARRAY[2::bigint],
    'User 1 should only see their 2 recipes'
);

-- Test 2: User 1 can create their own recipe
SELECT lives_ok(
    $$INSERT INTO recipes (id, user_id, title, ingredients, instructions) VALUES ('44444444-4444-4444-4444-444444444444'::uuid, '00000000-0000-0000-0000-000000000001'::uuid, 'Pizza', ARRAY['"Cheese"', '"Tomato"']::jsonb[], ARRAY['"Bake"', '"Air Fry"']::jsonb[])$$,
    'User 1 can create their own recipe'
);

-- as User 2
SET LOCAL request.jwt.claim.sub = '00000000-0000-0000-0000-000000000002';

-- Test 3: User 2 should only see their own recipe
SELECT results_eq(
    'select count(*) from recipes',
    ARRAY[1::bigint],
    'User 2 should only see their 1 recipe'
);

-- Test 4: User 2 cannot modify User 1's recipe
SELECT results_ne(
    $$ UPDATE recipes SET title = 'Hacked!' WHERE user_id = '00000000-0000-0000-0000-000000000001'::uuid returning 1 $$,
    $$ VALUES(1) $$,
    'User 2 cannot modify User 1 recipes'
);

SELECT finish();
ROLLBACK;
