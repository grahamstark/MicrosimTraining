begin
    md"""
    tax allowance: $(@bind tax_allowance NumberField(0:200:25000,default=12570.0)) (p.a.) 
    
    income tax rate: $(@bind income_tax_rate NumberField(0:1:100,default=21) )) (%)
    
    benefit withdrawal rate: $(@bind uc_taper NumberField(0:1:100,default=55) )) (%)
    """
end