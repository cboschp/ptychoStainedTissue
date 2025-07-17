function t = getSubTable(longT, keepIdx)
% makes a subtable and fixes categorical values (removing nonpresent
% categories in the subtable)

t = longT(keepIdx,:);

% remove unused categories
t.EM4cat = removecats(t.EM4cat);
t.XR4cat = removecats(t.XR4cat);
t.EM2cat = removecats(t.EM2cat);
t.XR2cat = removecats(t.XR2cat);
t.avgEM2cat = removecats(t.avgEM2cat);
t.avgXR2cat = removecats(t.avgXR2cat);
end