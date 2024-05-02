pageextension 80100 "Accountant Role Center" extends "Accountant Role Center"
{
    layout
    {
        modify(Control76)
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