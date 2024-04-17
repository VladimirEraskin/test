create or alter trigger dbo.tr_Basket_insert_update
on dbo.Basket
after insert
as
begin
	select i.ID_SKU
	into #ID_SKU
	from inserted as i
	group by i.ID_SKU
	having count(i.ID_SKU) >= 2
	
	if 2 <= any (select count(i.ID_SKU) from inserted as i group by i.ID_SKU)
		update b 
		set DiscountValue = b.Value * 0.05
		from dbo.Basket as b
		where ID_SKU in (select ID_SKU from #ID_SKU)
			and b.ID in (select i.ID from inserted as i)
	else
		update b 
		set DiscountValue = 0
		from dbo.Basket as b
		where ID_SKU not in (select ID_SKU from #ID_SKU)
			and b.ID in (select i.ID from inserted as i)
end
