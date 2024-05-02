pageextension 80103 "Order Processor Role Center" extends "Order Processor Role Center"
{
    layout
    {
        modify(Control104)
        {
            Visible = false;
        }
        addfirst(rolecenter)
        {
            part(CustomHeadline; "Headline RC Custom")
            {
                ApplicationArea = All;
            }
        }
    }
}