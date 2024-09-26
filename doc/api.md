# Digiline interface

## get shop status

```lua
digiline_send('channel', {
        type='get',
        only_items_on_sale_or_buy = false
    }
)
```

Response is sent to the same channel the instruction is sent to. `only_items_on_sale_or_buy` field is optional, if this field is set to `true`, items not give or accept by shop is hidden in response. Response from shop looks like this:

```lua
{
    type = "shop status",
    offer = {
        {
            give_count = 4,
            pay_count = 3,
            pay = "basenodes:cobble",
            stock = 0,
            give = "basenodes:dirt",
            pay_price = 0
        },
        {
            give_count = 25,
            pay_count = 1,
            pay = "currency:minegeld_10",
            stock = 1,
            give = "digilines:lcd",
            pay_price = 0.4
        },
        {
            give_count = 12,
            pay_count = 3,
            pay = "currency:minegeld_10",
            stock = 4,
            give = "digilines:lcd",
            pay_price = 2.5
        },
        {
            give_count = 9,
            pay_count = 3,
            pay = "currency:minegeld_10",
            stock = 5,
            give = "digilines:lcd",
            pay_price = 3.3333333333333
        }
    },
    inventory = {
        {
            meta = {

            },
            metadata = "",
            count = 25,
            name = "digilines:lcd",
            wear = 0
        },
        [5] = {
            meta = {

            },
            metadata = "",
            count = 3,
            name = "currency:minegeld_10",
            wear = 0
        },
        [28] = {
            meta = {
                    palette_index = "0"
            },
            metadata = "",
            count = 1,
            name = "testnodes:mesh_colorwallmounted",
            wear = 0
        }
    }
}
```

## set shop offer

Following program will set third slot of offer, then this slot will receive three cobble for four dirt:

```lua
digiline_send('channel', {
        type='set',
        offer={
            [3] = {give="basenodes:dirt",give_count=4,pay="basenodes:cobble",pay_count=3}
        }
    }
)
```

## notify on run out of items

Message will be received on the same channel set on smartshop, and looks like this:

```lua
{
    type = "out of storage",
    item = "basenodes:dirt"
}
```

