(*!------------------------------------------------------------
 * [[APP_NAME]] ([[APP_URL]])
 *
 * @link      [[APP_REPOSITORY_URL]]
 * @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
 * @license   [[LICENSE_URL]] ([[LICENSE]])
 *------------------------------------------------------------- *)

{%dependencies.inc}

{---put your middleware-related dependencies registration here---}

container.add(
    'throttle-one-request-per-minute',
    TThrottleMiddlewareFactory.create()
        .ratePerMinute(1)
        .rateLimiter(
            TDbRateLimiter.create(
                container['db'] as IRdbms,
                config.getString('rateLimiter.db.tableName'),
                config.getString('rateLimiter.db.idColumnName'),
                config.getString('rateLimiter.db.operationColumnName'),
                config.getString('rateLimiter.db.resetTimestampColumnName')
            )
        )
);