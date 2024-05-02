pageextension 80106 "Sales & Relationship Mgr. RC" extends "Sales & Relationship Mgr. RC"
{
    layout
    {
        modify(Control60)
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