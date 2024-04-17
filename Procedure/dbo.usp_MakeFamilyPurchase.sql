create or alter procedure dbo.usp_MakeFamilyPurchase
	@FamilySurName varchar(255)
as
begin
	declare @ErrorMessage varchar(4000)
		,@FamilyPurchase decimal(18,2)

	if not exists (
		select f.SurName
		from dbo.Family as f
		where @FamilySurName = f.SurName
	)
	begin
		set @ErrorMessage = 'Такой семьи не существует'
		raiserror(@ErrorMessage, 1, 1)

		return
	end

	select @FamilyPurchase = (sum(b.Value))
	from dbo.Basket as b
	where b.ID_Family = (select f.ID from dbo.Family as f where f.SurName = @FamilySurName)

	update f
	set BudgetValue = f.BudgetValue - @FamilyPurchase
	from dbo.Family as f
	where f.SurName = @FamilySurName
end
