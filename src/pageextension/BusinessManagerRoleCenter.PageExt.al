pageextension 80102 "Business Manager Role Center" extends "Business Manager Role Center"
{
    layout
    {
        modify(Control139)
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