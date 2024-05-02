pageextension 80107 "Security Admin Role Center" extends "Security Admin Role Center"
{
    layout
    {
        modify(Control6)
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